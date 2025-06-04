class Bloggers::SessionsController < Devise::SessionsController
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    render json: {
      email: resource.email,
      username: resource.username,
      message: 'Đăng nhập thành công!',
      id: resource.id
    }, status: :ok
  end

  def respond_to_on_destroy
    head :no_content
  end
end
