require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.


Bundler.require(*Rails.groups)

module TreckerT
  class Application < Rails::Application

    RGeo::ActiveRecord::SpatialFactoryStore.instance.tap do |config|
      # By default, use the GEOS implementation for spatial columns.
      config.default = RGeo::Geos.factory_generator

      # But use a geographic implementation for point columns.
      config.register(RGeo::Geographic.spherical_factory(srid: 4326), geo_type: "polygon")
    end
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
