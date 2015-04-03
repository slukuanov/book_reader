class Users::SessionsController < Devise::SessionsController
  def new
    self.resource = resource_class.new(sign_in_params)
    clean_up_passwords(resource)

    # using respond_to format breaks login modal dialog
    if request.xhr?
      respond_to do |format|
        format.html { render 'devise/sessions/new', locals: {ajax_form: true}, layout: false }
        format.js { render 'devise/sessions/new', locals: {ajax_form: true}, layout: false }
      end
      #render 'devise/sessions/new', locals: {ajax_form: true}, layout: false
    else
      respond_to do |format|
        format.html { render 'devise/sessions/new', locals: {ajax_form: false} }
        format.js { render 'devise/sessions/new', locals: {ajax_form: false} }
      end
      #render 'devise/sessions/new', locals: {ajax_form: false}
    end
  end
end