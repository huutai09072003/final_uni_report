require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Code is not reloaded between requests.
  config.enable_reloading = false

  # Eager load code on boot. This eager loads most of Rails and
  # your application in memory, allowing both threaded web servers
  # and those relying on copy on write to perform better.
  config.eager_load = true

  # Full error reports are disabled and caching is turned on.
  config.consider_all_requests_local = false

  # Disable server timing in production for security.
  config.server_timing = false

  # Configure hosts (Heroku domain).
  config.hosts << "inertia-native-ad24d88d5c88.herokuapp.com"

  # Enable caching.
  config.action_controller.perform_caching = true

  # Use Redis for caching (Heroku provides REDISCLOUD_URL).
  config.cache_store = :redis_cache_store, { url: ENV["REDISCLOUD_URL"] }
  config.public_file_server.headers = { "Cache-Control" => "public, max-age=#{1.year.to_i}" }

  # Store uploaded files on the cloud (Amazon S3 or similar).
  config.active_storage.service = :amazon # Thay bằng :local nếu chưa dùng S3
  # Nếu dùng S3, cấu hình Active Storage với Heroku domain
  config.active_storage.url_options = { host: "inertia-native-ad24d88d5c88.herokuapp.com" }

  # Ensure all mailers are sent.
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.perform_deliveries = true
  config.action_mailer.delivery_method = :smtp

  # Configure SMTP settings for Gmail (use ENV for secrets).
  config.action_mailer.smtp_settings = {
    address:              "smtp.gmail.com",
    port:                 587,
    domain:               "gmail.com",
    user_name:            ENV["SMTP_USERNAME"], # Lưu trong Heroku config vars
    password:             ENV["SMTP_PASSWORD"], # Lưu trong Heroku config vars
    authentication:       "plain",
    enable_starttls_auto: true
  }

  # Set default URL for mailer (Heroku domain).
  config.action_mailer.default_url_options = { host: "inertia-native-ad24d88d5c88.herokuapp.com" }

  # Enable caching for Action Mailer templates.
  config.action_mailer.perform_caching = true

  # Log deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Silence disallowed deprecations in production.
  config.active_support.disallowed_deprecation = :silence

  # Tell Active Support which deprecation messages to disallow.
  config.active_support.disallowed_deprecation_warnings = []

  # Do not raise an error on pending migrations in production (Heroku will handle).
  config.active_record.migration_error = false

  # Disable verbose query logs in production for performance.
  config.active_record.verbose_query_logs = false

  # Disable verbose enqueue logs for Active Job.
  config.active_job.verbose_enqueue_logs = false

  # Enable asset logging in production (optional).
  config.assets.quiet = false

  # Raise error for missing translations.
  config.i18n.raise_on_missing_translations = true

  # Do not annotate views in production.
  config.action_view.annotate_rendered_view_with_filenames = false

  # Enable Action Cable (ensure proper origin validation).
  config.action_cable.disable_request_forgery_protection = false
  config.action_cable.allowed_request_origins = ["https://inertia-native-ad24d88d5c88.herokuapp.com"]

  # Raise error for missing callback actions.
  config.action_controller.raise_on_missing_callback_actions = true

  # Apply autocorrection by RuboCop (optional).
  # config.generators.apply_rubocop_autocorrect_after_generate!
end