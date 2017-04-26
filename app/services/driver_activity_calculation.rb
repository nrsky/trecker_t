# Service calculates types of activity
# We would like you to create a scalable and distributed algorithm in order to classify the drivers actions into the following 3 activities:
# Driving - The driver is driving on the road. This means that the speed is more than 5 km/h and the location is not part of predefined fields (geofenced)
# Cultivating - The driver is working on a field. This means that the speed is more than 1 km/h and the location is part of predefined fields (geofenced)
# Repairing - The driver is repairing a machine on a field. This means that the speed is less than 1 km/h and the location is part of predefined fields (geofenced)

class DriverActivityCalculation

  NO_DATA_PROVIDED_TIME = 30

  def activities_for(driver_id, day, fields)


    result = ActivityResult.new

    scope = Record.search(query: ElasticQuery.records_for(driver_id, day)).sort_by(&:timestamp)
    current_record = scope.first
    scope.each do |record|
      time = Trecker::Math.instance.get_time(record.timestamp, current_record.timestamp)
      if time < NO_DATA_PROVIDED_TIME && time != 0
        speed = Trecker::Math.instance.get_distance(record.longitude, record.latitude, current_record.longitude, current_record.latitude)/(time*3600)
        if speed > 0
          work_on_predefined_fields = Trecker::Math.instance.part_of_fields?(fields, record.longitude, record.latitude)
          result.update_activities!(speed, work_on_predefined_fields, time, current_record.timestamp)
        end
      else
        result.reset_counters
      end
      current_record = record unless record == current_record
    end

    result.update_date_to!
    result.to_json
  end
end
