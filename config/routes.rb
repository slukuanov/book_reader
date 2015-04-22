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
  get '/favorite_list', to: 'books#favorite_list', as: 'user_favorite_list'
  get '/highlight_list', to: 'books#highlight_list', as: 'user_highlight_list'
  get '/delete_highlight/:id', to: 'books#delete_highlight', as: 'delete_highlight'
  post '/admin/categories/:id/move', to: 'admin/categories#move', as: 'move_admin_category'

  resources :books do
    collection do
      post :add_comment_to_highlighter
    end
  end
  resources :categories
  resources :book_readers do
    member do
      get :read
    end
    collection do
      post :update_book
      post :save_highlighter
      post :remove_highlighter
      post :get_highlighters
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
