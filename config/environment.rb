# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

Geocoder.configure(:units => :km)
