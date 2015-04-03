class Users::ConfirmationController < ApplicationController

  def confirm_user
    user = User.find_by_confirmation_token(params[:confirmation_token])
    if user.try(:update, {role: "confirmed"})
      redirect_to root_path, notice: 'Confirmation success'
    else
      redirect_to root_path, notice: 'Confirmation error'
    end
  end
end