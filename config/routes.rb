Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # ユーザー用　URL/users/sign_in...
  devise_for :users, controllers: {
    registrations: 'public/registrations',
    sessions: 'public/sessions',
    omniauth_callbacks: "users/omniauth_callbacks",
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
    get 'terms_of_use', to: 'homes#terms_of_use'
    get 'privacy_policy', to: 'homes#privacy_policy'
    get 'mypage' => 'users#mypage', as: 'mypage'
    get 'mypage/edit' => 'users#edit', as: 'edit_mypage'
    patch 'mypage' => 'users#update'
    get 'users/confirm' => 'users#confirm', as: 'confirm_user'
    patch 'users/close_account' => 'users#close_account', as: 'close_account_user'
    get 'users/check_name' => 'users#check_name'
    get 'users/check_email' => 'users#check_email'
    post 'users/check_user' => 'users#check_user'
    resources :users, only: [:show] do
      resource :relationships, only: [:create, :destroy]
        get 'followings' => 'relationships#followings', as: 'followings'
        get 'followers' => 'relationships#followers', as: 'followers'
    end
    resources :plans do
      resources :comments, only: [:create, :destroy]
      resource :like, only: [:create, :destroy]
      member do
        get :liked_users
      end
      collection do
        get :tags_list
      end
    end
    get 'search' => 'searches#search'
    get "search_tag" => "plans#search_tag"
    resources :chats, only: [:index, :create, :show]
    resources :notifications, only: [:index, :destroy] do
      collection do
        post 'mark_all_as_read', to: 'notifications#mark_all_as_read'
      end
      member do
        patch 'mark_as_read'
      end
    end
    resources :maps, only: [:index, :create, :destroy]
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
    resources :tags, only: [:index, :destroy]
    resources :chats, only: [:index, :show]
  end

end