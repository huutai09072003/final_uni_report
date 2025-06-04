class Bloggers::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  def create
    super do |resource|
      if resource.persisted?
        BloggerMailer.welcome_email(resource).deliver_later
      end
    end
  end

  private

  def respond_with(resource, _opts = {})
    if resource.persisted?
      render json: {
        id: resource.id,
        email: resource.email,
        username: resource.username,
        message: "Đăng ký thành công!"
      }, status: :created
    else
      render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def sign_up_params
    params.require(:blogger).permit(:email, :password, :password_confirmation, :username)
  end
end
