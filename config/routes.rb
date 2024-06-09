Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # ユーザー用　URL/users/sign_in...
  devise_for :users,skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }

  # 管理者用　URL/admin/sign_in...
  devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
    sessions: "admin/sessions"
  }

  devise_scope :user do
    post "users/guest_sign_in", to: "users/sessions#guest_sign_in"
  end

  scope module: :public do
    root to: 'homes#top'
    get 'mypage' => 'users#mypage', as: 'mypage'
    get 'mypage/edit' => 'users#edit', as: 'edit_mypage'
    patch 'mypage' => 'users#update'
    get 'users/confirm' => 'users#confirm', as: 'confirm_user'
    patch 'users/close_account' => 'users#close_account', as: 'close_account_user'
    resources :users, only: [:show]
    resources :plans do
      resources :comments, only: [:create, :destroy]
      resource :like, only: [:create, :destroy]
    end
    get "search" => "searches#search"
  end

  namespace :admin do
    root to: 'plans#index'
    resources :users, only: [:index, :show, :edit, :update, :destroy]
    resources :plans, only: [:show, :edit, :update, :destroy] do
      resources :comments, only: [:destroy]
    end
  end

end