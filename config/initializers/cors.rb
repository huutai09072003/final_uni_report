# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

# Avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin AJAX requests.

# Read more: https://github.com/cyu/rack-cors

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'http://localhost:5173' # later change to the domain of the frontend app
    resource '*',
            headers: %w[Authorization New_device Auth_token Refresh_token_expiry Refresh_token Auth_token_expiry Timezone],
            methods: :any,
            expose: %w[Authorization New_device Auth_token Refresh_token_expiry Refresh_token Auth_token_expiry],
            max_age: 600,
            credentials: true
  end
end
