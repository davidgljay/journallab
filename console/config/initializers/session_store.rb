# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_console_session',
  :secret      => 'c95a354712f93b9d1ae9e77dc894156a2009cab8fa2f3d551df6aac746e6fd2f756daa6fd852aeef65c9a729acec515b41a51cdd2f5768a8dc52f445a3dd52a5'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
