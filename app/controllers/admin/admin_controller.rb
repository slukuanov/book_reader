class Admin::AdminController < ApplicationController
  include ActionView::Helpers::TextHelper

  before_action :authenticate_user!
  before_action :check_permissions
  before_action :set_current_user

  layout "admin"

  def set_current_user
    User.current = current_user
  end

  def check_permissions
   raise CanCan::AccessDenied unless current_user.role == 'admin'
  end
end
