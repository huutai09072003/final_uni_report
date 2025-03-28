class Users::SessionsController < Devise::SessionsController
  def create
    self.resource = warden.authenticate!(auth_options)
    sign_in(resource_name, resource)
    flash[:notice] = 'Logged in successfully.'
    redirect_to wastes_path
  end

  def destroy
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    flash[:notice] = 'Logged out successfully.'
    redirect_to new_user_session_path
  end
end