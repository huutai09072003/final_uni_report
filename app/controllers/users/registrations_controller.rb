class Users::RegistrationsController < Devise::RegistrationsController
  def create
    super do |resource|
      if resource.persisted?
        flash[:notice] = 'Signed up successfully.'
        redirect_to posts_path and return
      end
    end
  end
end