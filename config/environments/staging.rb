Rails.application.configure do
  config.eager_load = true
  config.cache_classes = true

  config.consider_all_requests_local = true

  config.public_file_server.enabled = true
  config.assets.compile = false
  config.assets.digest = true

  config.active_storage.service = :amazon

  config.action_mailer.default_url_options = {
    host: ENV["STAGING_HOST"] || "your-staging-app.herokuapp.com",
    protocol: "https"
  }

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address:              "smtp.gmail.com",
    port:                 587,
    domain:               "gmail.com",
    user_name:            ENV["SMTP_USERNAME"],
    password:             ENV["SMTP_PASSWORD"],
    authentication:       "plain",
    enable_starttls_auto: true
  }

  config.active_job.queue_adapter = :sidekiq

  config.hosts.clear

  config.log_level = :debug
end
