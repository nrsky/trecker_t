class JsonParser

  def upload_fields_from(file)
    parsed_data = JSON.parse(file.read)
    total_count = 0
    if parsed_data && parsed_data['fields']
      total_count = parse_fields(parsed_data)
    elsif  parsed_data && parsed_data['records']
      total_count = parse_records(parsed_data)
    end
    total_count
  end

  def parse_fields(parsed_data)
    uploaded_count = 0
    parsed_data['fields'].each do |field_item|
      begin
        Field.create(name: field_item['name'], shape: "POLYGON ((#{field_item['polygon']}))")
        uploaded_count = uploaded_count + 1
      rescue Exception => exception
        logger.error "Couldn't add field: " + exception.message
      end
    end
    uploaded_count
  end

  def parse_records(parsed_data)
    uploaded_count = 0
    parsed_data['records'].each do |record_item|
      begin
        Record.create(driver_id:  record_item['driver_id'],
                      company_id: record_item['company_id'],
                      timestamp: DateTime.parse(record_item['timestamp']),
                      latitude: record_item['latitude'],
                      longitude: record_item['longitude'],
                      accuracy: record_item['accuracy'],
                      speed: record_item['speed']
        )
        uploaded_count = uploaded_count + 1
      rescue Exception => exception
        logger.error "Couldn't add record: " + exception.message
      end
    end
    uploaded_count
  end
end
