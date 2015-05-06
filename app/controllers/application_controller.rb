class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :update_user_language, if: :locale?
  before_action :set_locale

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(
          :email, :password, :password_confirmation, :first_name, :last_name,
          :provider, :uid, :birthday, :location, :picture, :newsletter
      )
    end
  end

  private
  def set_locale
    if user_signed_in?
      I18n.locale = current_user.try(:language) || session[:user_language] || I18n.default_locale
    else
      I18n.locale = session[:user_language] || I18n.default_locale
    end
  end

  def update_user_language
    if user_signed_in?
      session[:user_language] = params[:locale]
      if params[:locale] != current_user.language
        current_user.update({language: params[:locale]})
      end
    else
      session[:user_language] = params[:locale]
    end
  end

  def locale?
    params.has_key?(:locale)
  end
end
