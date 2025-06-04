# app/mailers/subscriber_mailer.rb
class SubscriberMailer < ApplicationMailer
  def confirmation_email(subscriber)
    @subscriber = subscriber
    mail(to: @subscriber.email, subject: "Xác nhận đăng ký thành công")
  end
end
