# app/controllers/bloggers/registrations_controller.rb
class Users::RegistrationsController < Devise::RegistrationsController
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token, only: :create

  def create
    super do |resource|
      if resource.persisted?
        flash[:notice] = "Đăng ký thành công! Hãy bắt đầu chia sẻ bài viết đầu tiên của bạn 🌱"
      end
    end
  end
end