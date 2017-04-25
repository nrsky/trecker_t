require 'singleton'

module Trecker
  class Math
    include Singleton

    def get_distance(lon1, lat1, lon2, lat2)
      Geocoder::Calculations.distance_between([lon1, lat1], [lon2, lat2])
    end

    def get_time(end_time, start_time)
      result = (end_time - start_time)
      result = result* 1.days if result.is_a?(Rational)
      result
    end

    def part_of_fields?(fields, longitude, latitude)
      fields.any? { |field| field.contains?(geo_factory.point(longitude, latitude)) }
    end

    def geo_factory
      RGeo::Geographic.spherical_factory
    end
  end
end
