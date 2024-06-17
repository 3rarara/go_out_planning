Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # ユーザー用　URL/users/sign_in...
  devise_for :users,skip: [:passwords], controllers: {
    registrations: 'public/registrations',
    sessions: 'public/sessions'
  }

  # 管理者用　URL/admin/sign_in...
  devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
    sessions: 'admin/sessions'
  }

  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
  end

  scope module: :public do
    root to: 'homes#top'
    get 'mypage' => 'users#mypage', as: 'mypage'
    get 'mypage/edit' => 'users#edit', as: 'edit_mypage'
    patch 'mypage' => 'users#update'
    get 'users/confirm' => 'users#confirm', as: 'confirm_user'
    patch 'users/close_account' => 'users#close_account', as: 'close_account_user'
    resources :users, only: [:show] do
      resource :relationships, only: [:create, :destroy]
        get 'followings' => 'relationships#followings', as: 'followings'
        get 'followers' => 'relationships#followers', as: 'followers'

      member do
        get :drafts
        get :likes
      end
    end
    resources :plans do
      resources :comments, only: [:create, :destroy]
      resource :like, only: [:create, :destroy]
    end
    get 'search' => 'searches#search'
    get "search_tag" => "plans#search_tag"
    resources :chats, only: [:create, :show]
    resources :notifications, only: [:index, :destroy]
    resource :map, only: [:show]
  end

  namespace :admin do
    root to: 'plans#index'
    resources :users, only: [:index, :edit, :update, :destroy] do
      member do
        get :drafts
      end
    end
    resources :plans, only: [:edit, :update, :destroy] do
      resources :comments, only: [:destroy]
    end
    get 'search' => 'searches#search'
  end

end