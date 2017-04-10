class DriverActivityService

  # We would like you to create a scalable and distributed algorithm in order to classify the drivers actions into the following 3 activities:
  # Driving - The driver is driving on the road. This means that the speed is more than 5 km/h and the location is not part of predefined fields (geofenced)
  # Cultivating - The driver is working on a field. This means that the speed is more than 1 km/h and the location is part of predefined fields (geofenced)
  # Repairing - The driver is repairing a machine on a field. This means that the speed is less than 1 km/h and the location is part of predefined fields (geofenced)

  def activities_for(driver_id, time_from, time_to)
    fields = Field.all.map(&:shape)
    processing_time =  {driving_time: 0, cultivating_time: 0, reparing_time: 0}

    #TODO move to configs
    Geocoder.configure(:units => :km)
    geo_factory = RGeo::Geographic.spherical_factory

    scope = RecordIndex::Record.query(term: {driver_id: driver_id}).order(timestamp: :desc)

    #NOTE next implementation for Chewy query
    current_record = scope.first

    scope.each do |record|
      time = get_time(record.timestamp, current_record.timestamp)
      speed = get_distance(record.location, current_record.location)/time
      work_on_predefined_fields = part_of_fields?(geo_factory, fields, record.location['lon'], record.location['lat'])
      update_processing_time!(processing_time, speed, time, work_on_predefined_fields)

      #NOTE next implementation for Chewy query
      current_record = record unless record == current_record
    end

    processing_time
  end

  private

  def get_distance(location1, location2)
    Geocoder::Calculations.distance_between([location1['lon'], location1['lat']], [location2['lon'], location2['lat']])
  end

  def get_time(time1, time2)
    (Time.parse(time1) - Time.parse(time2)).abs
  end

  def update_processing_time!(processing_time, speed, time, part_of_fields)
    if speed > 5 && !part_of_fields
      processing_time[:driving_time] = processing_time[:driving_time] + time
    elsif (speed <= 5 && speed >= 1 && part_of_fields)
      processing_time[:cultivating_time] = processing_time[:cultivating_time] + time
    elsif speed < 1 && part_of_fields
      processing_time[:reparing_time] = processing_time[:reparing_time] + time
    end
  end

  def part_of_fields?(geo_factory, fields, lon, lat)
    fields.each do |field|
      return true if field.contains?(geo_factory.point(lon,lat))
    end
    false
  end
end
