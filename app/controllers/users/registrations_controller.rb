class Users::RegistrationsController < Devise::RegistrationsController
  skip_before_action :verify_authenticity_token, only: [:create]
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    if resource.persisted?
      render json: { message: 'Signed up successfully.', user: resource, token: request.env['warden-jwt_auth.token'] }, status: :ok
    else
      render json: { message: 'Sign up failed.', errors: resource.errors.full_messages }, status: :unprocessable_entity
    end
  end
end