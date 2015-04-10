class Admin::UsersController < Admin::AdminController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :become, :reset_password, :update_tariff]
  skip_before_filter :verify_authenticity_token, only: [:search]

  def index
    @users = User.all
    respond_to do |format|
      format.html
    end
  end

  def sort_by_id
    @users = User.sort_by_id
    render "index"
  end

  def sort_by_first_name
    @users = User.sort_by_first_name
    render "index"
  end

  def sort_by_last_name
    @users = User.sort_by_first_name
    render "index"
  end

  def sort_by_last_seen
    @users = User.sort_by_last_seen
    render "index"
  end

  def sort_by_role
    @users = User.sort_by_role
    render "index"
  end

  def search
    @search_query = params[:search_query]
    @users = User.search(@search_query)
    render 'index'
  end

  def edit
  end

  def show
  end

  def update
    if @user.update(user_params)
      redirect_to admin_user_path(@user), success: t('flash.user.update.success')
    else
      render "edit"
    end
  end

  def destroy
    if @user.destroy
      redirect_to :action => "index"
    else
      redirect_to :action => "index"
    end
  end

  def become
    sign_in(:user, @user)
    redirect_to root_url
  end

  def reset_password
    if @user.update(user_params)
      render :json => { user_email: @user.email }
    else
      render :json => { status: 403 }
    end
  end

  def update_tariff
    if @user.update(user_params)
      render :json => { user_email: @user.email }
    else
      render :json => { status: 403 }
    end
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      attributes = params.require(:user).permit(:email, :last_name, :first_name, :location, :birthday, :avatar,
                                                :password_confirmation, :password, :role, :language, :tariff_type, :expire_date)
      if attributes[:password].blank?
        attributes.delete :password
        attributes.delete :password_confirmation
      else
        attributes.store(:has_password, true)
      end
      attributes
    end
end
