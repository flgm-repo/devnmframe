# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_NameFrame_session',
  :secret      => 'e5b98a98db9c520d28cd52a05f3fadcafd8f751237606178506f4d9ddcd27e74448e3407efc3c6baf11bbc22936dc124af1862ef1af3f1eafc2b8f75635bd873'
}

#ActionController::Dispatcher.middleware.insert_before(
#  ActionController::Session::CookieStore,
#  FlashSessionCookieMiddleware,
#  ActionController::Base.session_options[:key]
#)

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
