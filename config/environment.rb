# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.3' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|

  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )
  #  %w(observers sweepers mailers middleware).each do |dir|
  #    config.load_paths << "#{RAILS_ROOT}/app/#{dir}"
  #  end
  # Specify gems that this application depends on and have them installed with rake gems:install
  # config.gem "bj"
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "sqlite3-ruby", :lib => "sqlite3"
  # config.gem "aws-s3", :lib => "aws/s3"
  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  config.gem 'mime-types', :lib => 'mime/types', :version => '1.16'
  config.gem 'uuidtools', :version => '2.1.1'
  config.gem 'money', :version => '2.2.0'
  config.gem "sendgrid", :source => 'http://gemcutter.org'
#  config.gem 'rmagick', :version => '2.12.2', :lib => 'RMagick'
  config.gem "chronic", :version => '0.2.3'
  config.gem 'rails-settings', :lib => 'settings'
  config.gem 'javan-whenever', :lib => false, :source => 'http://gems.github.com'
  config.action_controller.session = {
    :httponly => false,
    :session_key => '_rails-swfupload_session',
    :secret      => 'e039e0753a1ea545002c0f1c41abf3f44eb36f2a64de0564cb3ff8b1be7070b552be355c2221ea9787f6154782f1af1e62c6cbf95c3a1fac2721bff9825a09da'
  }

  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'UTC'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :de

end

SERVER_URL = "http://69.65.41.139:3001"

Mime::Type.register "image/png", :png
require "asset_tag_helper_ext"
# LOGGER
#ActiveRecord::Base.logger = Logger.new(STDOUT)
#ActiveRecord::Base.logger = Log4r::Logger.new("Application Log") 