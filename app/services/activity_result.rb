class ActivityResult
  attr_accessor :result

  WORKS = [:driving, :cultivating, :repairing]

  def initialize
    @result = {}
    WORKS.each {|type| @result[type] =  Activity.new(type) }
  end

  def update_activities!(speed, part_of_fields, time, timestamp)
    if speed > 5 && !part_of_fields
      update(:driving, time, timestamp)
    elsif (speed <= 5 && speed >= 1 && part_of_fields)
      update(:cultivating, time, timestamp)
    elsif speed < 1 && part_of_fields
      update(:repairing, time, timestamp)
    end
  end

  def update(type, time, timestamp)
    current_index = @result[type].current_index
    if @result[type].data.blank? || @result[type].data[current_index].blank?
      @result[type].data << {date_from: timestamp, total_time: time}
    else
      @result[type].data[current_index][:total_time] += time
    end
  end

  def reset_counters
    WORKS.each { |type|  @result[type.to_sym].current_index += 1 }
  end

  def update_date_to
    WORKS.each { |type|  @result[type.to_sym].add_date_to }
  end
end
