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

  scope module: :public do
    root to: 'homes#top'
    get 'mypage' => 'users#mypage', as: 'mypage'
    get 'mypage/edit' => 'users#edit', as: 'edit_mypage'
    patch 'mypage' => 'users#update'
    get 'users/confirm' => 'users#confirm', as: 'confirm_user'
    patch 'users/close_account' => 'users#close_account', as: 'close_account_user'
    resources :users, only: [:show]
    resources :plans, only: [:new, :index, :show, :create, :edit, :update, :destroy] do
      resources :plan_details, only: [:new, :index, :show, :create, :edit, :update, :destroy]
    end
  end

end