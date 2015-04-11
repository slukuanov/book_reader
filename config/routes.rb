Rails.application.routes.draw do
  devise_for :users, :controllers => {
      :omniauth_callbacks => "users/omniauth_callbacks",
      :registrations => "users/registrations",
      :sessions => 'users/sessions'
  }
  get 'welcome/index'
  root 'welcome#index'

  get '/user/send_confirmation_email', to: 'users/users#send_confirmation_email', as: 'send_confirmation_email'
  delete '/user/fb_account_delete', to: 'users/users#remove_fb_account', as: 'remove_fb_account'
  get '/account/confirm/:confirmation_token', to: 'users/confirmation#confirm_user', as: 'confirmation'

  resources :books
  resources :categories
  resources :book_readers do
    member do
      get :read
    end
    collection do
      post :update_current_chapter
    end
  end

  namespace :admin do
    resources :users, except: [:new, :create] do
      collection do
        get :sort_by_id
        get :sort_by_first_name
        get :sort_by_last_seen
        get :sort_by_role
        post :search
        post :reset_password
        post :update_tariff
      end
      member do
        get :become
      end
    end

    resources :categories do
      collection do
        post :search
      end
    end

    resources :books do
      collection do
        post :search
      end
    end

    resources :chapters do
      collection do
        post :get_chapter
        post :save_chapter
        post :generate_new_chapter
        post :destroy_chapter
      end
    end
    get '' => 'dashboard#index'
  end
end
