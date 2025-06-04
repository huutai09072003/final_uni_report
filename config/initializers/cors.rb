# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

# Avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin AJAX requests.

# Read more: https://github.com/cyu/rack-cors

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'http://localhost:8081', 'http://192.168.1.9:8081', 'http://localhost:5173',
            'https://green-world-three.vercel.app',
            'https://green-world-git-main-nguyen-huynh-huu-tais-projects.vercel.app',
            'https://green-world-fowxkisc-nguyen-huynh-huu-tais-projects.vercel.app'

    resource '*',
             headers: :any,
             methods: [:get, :post, :put, :patch, :delete, :options, :head],
             expose: %w[Authorization Auth_token Refresh_token],
             credentials: true
  end
end