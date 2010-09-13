# Settings specified here will take precedence over those in config/environment.rb
SITE_URL = "127.0.0.1:3000"
# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
config.cache_classes = false

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_view.debug_rjs                         = true
config.action_controller.perform_caching             = false
config.action_controller.asset_host = "http://#{SITE_URL}"

# Using Mailtrap for simulating the email sending
# Run "sudo mailtrap start", log file stored at /var/tmp/mailtrap.log by default
# More information at: http://matt.blogs.it/entries/00002655.html


# Don't care if the mailer can't send
config.action_mailer.delivery_method           = :smtp
config.action_mailer.raise_delivery_errors     = true
config.action_mailer.perform_deliveries        = true
config.action_mailer.default_charset           = "utf-8"
config.action_mailer.default_url_options = { :host => SITE_URL }
config.action_mailer.smtp_settings             = {
  :address => "localhost",
  :port => "25",
  :domain => "localhost"
 }

ADMIN_EMAIL_ACCOUNT = "sysadmin@vikiyagroup.com"

#ActionMailer::Base.smtp_settings = {
#  :tls => true,
#  :address => "smtp.gmail.com",
#  :port => "587",
#  :domain => "hifimaven.com",
#  :authentication => :plain,
#  :user_name => "admin@hifimaven.com", # !!notice that your username must include your domain!
#  :password => 'D4'
#}

#Disable SSL for development production
SslRequirement.disable_ssl_check = true
