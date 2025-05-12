class Users::SessionsController < Devise::SessionsController
  include ActionController::MimeResponds
  respond_to :json

  def create
    user = User.find_for_authentication(email: params.dig(:user, :email))

    unless user&.valid_password?(params.dig(:user, :password))
      return render_unauthorized('Email hoặc mật khẩu không chính xác.')
    end

    sign_in(resource_name, user)

    render json: {
      success: true,
      user: {
        id: user.id,
        email: user.email,
        name: user.name || user.email.split("@").first,
        role: user.role,
        location: user.location,
        recycling_goal: user.recycling_goal,
        points: user.points,
        unread_notifications_count: user.notifications.unread.count
      }
    }, status: :ok
  end

  def destroy
    sign_out(resource_name)
    render json: { success: true, message: 'Đăng xuất thành công.' }, status: :ok
  end

  private

  def render_unauthorized(message)
    render json: { success: false, message: message }, status: :unauthorized
  end
end
