require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Code is not reloaded between requests.
  config.enable_reloading = false

  # Eager load code on boot.
  config.eager_load = true

  # Show limited error reports (for debugging).
  config.consider_all_requests_local = true

  # Enable server timing for debugging.
  config.server_timing = true

  # Configure hosts (Heroku staging domain).
  config.hosts << "inertia-native-ad24d88d5c88.herokuapp.com" # Thay bằng domain thực tế

  # Enable caching.
  config.action_controller.perform_caching = true
  config.action_controller.enable_fragment_cache_logging = true

  # Use Redis for caching (Heroku provides REDISCLOUD_URL).
  config.cache_store = :redis_cache_store, { url: ENV["REDISCLOUD_URL"] }
  config.public_file_server.headers = { "Cache-Control" => "public, max-age=#{1.day.to_i}" }

  # Store uploaded files on the cloud (Amazon S3) or local for staging.
  config.active_storage.service = :amazon # Hoặc :local nếu chưa dùng S3
  config.active_storage.url_options = { host: "inertia-native-ad24d88d5c88.herokuapp.com" } # Thay domain

  # Ensure mailers are sent (for testing).
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.perform_deliveries = true
  config.action_mailer.delivery_method = :smtp

  # Configure SMTP settings for Gmail.
  config.action_mailer.smtp_settings = {
    address:              "smtp.gmail.com",
    port:                 587,
    domain:               "gmail.com",
    user_name:            ENV["SMTP_USERNAME"],
    password:             ENV["SMTP_PASSWORD"],
    authentication:       "plain",
    enable_starttls_auto: true
  }

  # Set default URL for mailer (staging domain).
  config.action_mailer.default_url_options = { host: "inertia-native-ad24d88d5c88.herokuapp.com" }

  # Enable caching for Action Mailer templates.
  config.action_mailer.perform_caching = true

  # Log deprecation notices.
  config.active_support.deprecation = :log

  # Raise disallowed deprecations (for debugging).
  config.active_support.disallowed_deprecation = :raise

  # Tell Active Support which deprecation messages to disallow.
  config.active_support.disallowed_deprecation_warnings = []

  # Do not raise error on pending migrations (Heroku will handle).
  config.active_record.migration_error = false

  # Enable verbose query logs for debugging.
  config.active_record.verbose_query_logs = true

  # Enable verbose enqueue logs for Active Job.
  config.active_job.verbose_enqueue_logs = true

  # Enable asset logging.
  config.assets.quiet = false

  # Raise error for missing translations.
  config.i18n.raise_on_missing_translations = true

  # Annotate views for debugging.
  config.action_view.annotate_rendered_view_with_filenames = true

  # Enable Action Cable (with proper origin validation).
  config.action_cable.disable_request_forgery_protection = false
  config.action_cable.allowed_request_origins = ["https://inertia-native-ad24d88d5c88.herokuapp.com"]

  # Raise error for missing callback actions.
  config.action_controller.raise_on_missing_callback_actions = true
end