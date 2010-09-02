# Settings specified here will take precedence over those in config/environment.rb

SITE_URL = "www.nameframe.com"

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true
config.action_view.cache_template_loading            = true
config.action_controller.asset_host = Proc.new { |source, request|
  if request && request.ssl?
    "https://#{SITE_URL}"
  else
    "http://#{SITE_URL}"
  end
}

# See everything in the log (defaul174174t is :info)
# config.log_level = :debug

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Use a different cache store in production
# config.cache_store = :mem_cache_store

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host = "http://assets.example.com"

# Disable delivery errors, bad email addresses will be ignored
# config.action_mailer.raise_delivery_errors = false

# Enable threaded mode
# config.threadsafe!
config.action_mailer.default_url_options = { :host => SITE_URL }
config.action_mailer.perform_deliveries = true
config.action_mailer.delivery_method = :smtp
config.action_mailer.default_content_type = "text/html"

ActionMailer::Base.smtp_settings = {
  :address => "smtp.sendgrid.net",
  :port => '25',
  :domain => "nameframe.com",
  :authentication => :plain,
  :user_name => "camera@vantuil.com",
  :password => "vantuil"
}
