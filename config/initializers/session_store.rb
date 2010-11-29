# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_bcms_settings_session',
  :secret      => '65e12a21820e6e7e1f51080b1bd14abfd0f8a2be7898b4da3c64ebc64c1c56df574a8dcb9d398877a4bc3a3d5fe0c9ffc74bd81cb795435aa782986a97659455'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
