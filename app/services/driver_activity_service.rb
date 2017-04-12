class DriverActivityService
  
  NO_DATA_PROVIDED_TIME = 30

  # We would like you to create a scalable and distributed algorithm in order to classify the drivers actions into the following 3 activities:
  # Driving - The driver is driving on the road. This means that the speed is more than 5 km/h and the location is not part of predefined fields (geofenced)
  # Cultivating - The driver is working on a field. This means that the speed is more than 1 km/h and the location is part of predefined fields (geofenced)
  # Repairing - The driver is repairing a machine on a field. This means that the speed is less than 1 km/h and the location is part of predefined fields (geofenced)

  #TODO refactoring clean it up
  def activities_for(driver_id, day)
    fields = Field.all.map(&:shape)
    return if fields.empty?


    result =    {
        driving: {data: [], current_index: 0},
        cultivating: {data: [], current_index: 0},
        repairing: {data: [], current_index: 0}
    }


    #TODO move to configs
    Geocoder.configure(:units => :km)
    geo_factory = RGeo::Geographic.spherical_factory

    #TODO Research chewy add filter gte then day start time and lte then day end time
    scope = RecordIndex::Record.query(term: {driver_id: driver_id}).filter{ ~(timestamp.to_datetime >= Date.yesterday.beginning_of_day) & (timestamp.to_datetime <= Date.yesterday.at_end_of_day) }.sort_by(&:timestamp)

    #NOTE next implementation for Chewy query
    current_record = scope.first

    scope.each do |record|
      time = get_time(record.timestamp, current_record.timestamp)

      if time < NO_DATA_PROVIDED_TIME
      #add verification if time == 0, to exclude duplications
      speed = get_distance(record.location, current_record.location)/(time*3600)

      #TODO this is the check for 0 speed, means that we have some duplications or first/last. Should be changed, #ugly
      if speed > 0
        work_on_predefined_fields = part_of_fields?(geo_factory, fields, record.location['lon'], record.location['lat'])
        update_activities!(result, speed, work_on_predefined_fields, time, current_record.timestamp)
      end

      else
        reset_counters(result)
      end

      #NOTE next implementation for Chewy query
      current_record = record unless record == current_record
    end


    clean_result(result)
  end

  private

  def get_distance(location1, location2)
    Geocoder::Calculations.distance_between([location1['lon'], location1['lat']], [location2['lon'], location2['lat']])
  end

  def get_time(time1, time2)
    (Time.parse(time1) - Time.parse(time2)).abs
  end

  def update_result_hash!(result, activity, time, timestamp)
    #TODO update to dynamic, ugly
    current_index  = result[activity.to_sym][:current_index]
    if result[activity.to_sym][:data].blank? || result[activity.to_sym][:data][current_index].blank?
      result[activity.to_sym][:data] << {date_from: timestamp, total_time: time}
    else
      result[activity.to_sym][:data][current_index][:total_time] =  result[activity.to_sym][:data][current_index][:total_time] + time
    end
  end

  def update_activities!(result, speed, part_of_fields, time, timestamp)
    if speed > 5 && !part_of_fields
      update_result_hash!(result, :driving, time, timestamp)
    elsif (speed <= 5 && speed >= 1 && part_of_fields)
      update_result_hash!(result, :cultivating, time, timestamp)
    elsif speed < 1 && part_of_fields
      update_result_hash!(result, :repairing, time, timestamp)
    end
  end

  def reset_counters(result)
    #TODO update to dynamic, ugly

    result[:driving][:current_index] = result[:driving][:current_index] + 1
    result[:cultivating][:current_index] = result[:cultivating][:current_index] + 1
    result[:repairing][:current_index] = result[:repairing][:current_index] + 1
  end


  def part_of_fields?(geo_factory, fields, lon, lat)
    fields.each do |field|
      return true if field.contains?(geo_factory.point(lon,lat))
    end
    false
  end

  def  clean_result(result)
    result.each do |key, value|
      value.except!(:current_index)
      add_date_to_to_all_elements(value[:data])
    end
    result
  end

  def add_date_to_to_all_elements(data_list)
    if data_list.present?
      data_list.each do |data|
        data[:date_to] = (DateTime.parse(data[:date_from]) + data[:total_time].seconds)   if data[:date_from].present?
      end
    end
  end
end
