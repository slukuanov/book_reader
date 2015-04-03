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
end
