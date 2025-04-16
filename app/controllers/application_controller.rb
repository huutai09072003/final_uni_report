class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # allow_browser versions: :modern
  before_action :configure_permitted_parameters, if: :devise_controller?

  inertia_share do
    {
      auth: {
        user: current_user&.as_json(only: [:id, :email]),
        unread_notifications_count: current_user&.notifications&.unread&.count || 0
      },
      flash: flash.to_hash
    }
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :location, :recycling_goal, :role])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :location, :recycling_goal, :role])
  end
end