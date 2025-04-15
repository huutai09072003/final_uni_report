class Users::RegistrationsController < Devise::RegistrationsController
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token, only: :create

  def create
    super do |resource|
      if resource.persisted?
        flash[:notice] = 'Signed up successfully.'
      end
    end
  end
end