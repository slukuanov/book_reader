class Users::RegistrationsController < Devise::RegistrationsController
  before_action :set_user
  before_action :authenticate_user!
  respond_to :html, :json

  def new
    build_resource({})

    if request.xhr?
      respond_to do |format|
        format.html { render "devise/registrations/new", locals: {ajax_form: true}, :layout => false }
        format.js { render "devise/registrations/new", locals: {ajax_form: true}, :layout => false }
      end
    else
      respond_to do |format|
        format.html { render "devise/registrations/new", locals: {ajax_form: false} }
        format.js { render "devise/registrations/new", locals: {ajax_form: false} }
      end
    end
  end

  def create
    build_resource(sign_up_params)

    if resource.save
      sign_up(resource_name, resource)
      respond_to do |format|
        format.html { render "devise/registrations/new" }
        format.json { true }
      end
      # render json: true
    else
      respond_to do |format|
        format.html { render "devise/registrations/new" }
        format.json { render json: resource.errors, status: 403 }
      end
    end
  end

  def update
    if @user.update(user_params)
      set_flash_message :notice, :updated
      redirect_to edit_user_registration_path
    else
      flash[:error] = 'Update error'
      render "edit"
    end
  end

  def update_password
    if set_new_password
      sign_in @user, :bypass => true
      redirect_to edit_user_registration_path
    else
      flash[:error] = 'Update error'
      render "edit"
    end
  end

  private
  def user_params
    params.require(:user).permit(:email, :last_name, :first_name, :location, :birthday, :avatar)
  end

  def user_password_params
    attributes = params.require(:user).permit(:password, :password_confirmation, :current_password)
    unless @user.has_password?
      attributes.delete :current_password
      attributes.store(:has_password, true)
    end
    attributes
  end

  def set_user
    @user = current_user
  end

  def set_new_password
    if @user.has_password?
      @user.update_with_password(user_password_params)
    else
      @user.update(user_password_params)
    end
  end
end