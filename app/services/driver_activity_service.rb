# Service calculates types of activity
# We would like you to create a scalable and distributed algorithm in order to classify the drivers actions into the following 3 activities:
# Driving - The driver is driving on the road. This means that the speed is more than 5 km/h and the location is not part of predefined fields (geofenced)
# Cultivating - The driver is working on a field. This means that the speed is more than 1 km/h and the location is part of predefined fields (geofenced)
# Repairing - The driver is repairing a machine on a field. This means that the speed is less than 1 km/h and the location is part of predefined fields (geofenced)

require 'elasticsearch/persistence'
class DriverActivityService

  NO_DATA_PROVIDED_TIME = 30
  WORKS = [:driving, :cultivating, :repairing]

  def activities_for(driver_id, day)
    fields = Field.all.map(&:shape)
    return if fields.empty?

    result = {}
    WORKS.each {|type| result[type] = {data: [], current_index: 0}}

    #TODO move to configs
    Geocoder.configure(:units => :km)

    scope = create_scope(driver_id, day)
    current_record = scope.first
    scope.each do |record|
      time = get_time(record.timestamp, current_record.timestamp)
      if time < NO_DATA_PROVIDED_TIME && time != 0
        speed = get_distance(record.longitude, record.latitude, current_record.longitude, current_record.latitude)/(time*3600)
        if speed > 0
          work_on_predefined_fields = part_of_fields?(fields, record.longitude, record.latitude)
          update_activities!(result, speed, work_on_predefined_fields, time, current_record.timestamp)
        end
      else
        reset_counters(result)
      end

      current_record = record unless record == current_record
    end

    print clean_result(result).to_json
  end

  private

  def create_scope(driver_id, day)
    repository = Elasticsearch::Persistence::Repository.new

    repository.search(query:
                          {constant_score:
                               {filter:
                                    {bool:
                                         {must:
                                              [{term:
                                                    {driver_id: driver_id}},
                                               {range: {timestamp: {gte: "#{day}T00:00:00", lte: "#{day}T23:59:59"}}}
                                              ]
                                         }
                                    }
                               }
                          }
    ).sort_by(&:timestamp)
  end

  def get_distance(lon1, lat1, lon2, lat2)
    Geocoder::Calculations.distance_between([lon1, lat1], [lon2, lat2])
  end

  def get_time(end_time, start_time)
    result = (end_time - start_time)
    result = result* 1.days if result.is_a?(Rational)
    result
  end

  def update_result_hash!(result, activity, time, timestamp)
    #TODO update to dynamic, ugly
    current_index = result[activity.to_sym][:current_index]
    if result[activity.to_sym][:data].blank? || result[activity.to_sym][:data][current_index].blank?
      result[activity.to_sym][:data] << {date_from: timestamp, total_time: time}
    else
      result[activity.to_sym][:data][current_index][:total_time] = result[activity.to_sym][:data][current_index][:total_time] + time
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
    WORKS.each { |type| result[type][:current_index] += 1 }
  end

  def part_of_fields?(fields, longitude, latitude)
    fields.any? { |field| field.contains?(geo_factory.point(longitude, latitude)) }
  end

  def clean_result(result)
    result.each do |key, value|
      value.except!(:current_index)
      add_date_to_to_all_elements(value[:data])
    end
    result
  end

  def add_date_to_to_all_elements(data_list)
    if data_list.present?
      data_list.each do |data|
        data[:date_to] = (data[:date_from] + data[:total_time].seconds) if data[:date_from].present?
      end
    end
  end

  def geo_factory
    RGeo::Geographic.spherical_factory
  end
end
