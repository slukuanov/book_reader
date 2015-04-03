class ConfirmationMailer < ActionMailer::Base
  default from: "contact@docnhanh.com"

  def confirmation_email(user)
    @user = user
    @url = confirmation_url(@user.confirmation_token)
    @email_obj = "Notification about new account"
    mail(to: @user.email, subject: @email_obj)
    @user.update({confirmation_sent_at: Time.now})
  end
end
