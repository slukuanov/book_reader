class Users::UsersController < ApplicationController
  before_action :set_user, except: [:done]
  before_action :authenticate_user!, except: [:done]

  def show
  end

  def send_confirmation_email
    @user.send_confirmation_email
    redirect_to edit_user_registration_path, success: 'Confirmation success'
  end

  def remove_fb_account
    if @user.has_password?
      @user.update({provider: nil, uid: nil})
      redirect_to edit_user_registration_path
    else
      redirect_to edit_user_registration_path, error: 'Error'
    end
  end
  def done
    render layout: false
  end

  private
  def set_user
    @user = current_user
  end
end