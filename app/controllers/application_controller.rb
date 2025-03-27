class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # allow_browser versions: :modern
  inertia_share do
    {
      auth: { user: current_user&.as_json(only: [:id, :email]) },
      flash: flash.to_hash
    }
  end
end
