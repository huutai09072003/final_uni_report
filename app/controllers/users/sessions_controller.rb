class Users::SessionsController < Devise::SessionsController
  skip_before_action :verify_authenticity_token, only: :create

  
  def create
    self.resource = warden.authenticate!(auth_options)
    sign_in(resource_name, resource)
    response.set_header('X-CSRF-Token', form_authenticity_token)
    flash[:notice] = 'Logged in successfully.'
    redirect_to wastes_path
  end

  def destroy
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    flash[:notice] = 'Logged out successfully.'
    redirect_to login_auth_path
  end
end