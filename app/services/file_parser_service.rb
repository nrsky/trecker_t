class FileParserService

  def upload_fields_from(file, type)
    parsed_data = JSON.parse(file)
    uploaded_count = 0
    if type == 'fields'
      uploaded_count = parse_fields(parsed_data, uploaded_count)
    elsif type == 'records'
      uploaded_count = parse_records(parsed_data, uploaded_count)
    end
    uploaded_count
  end

  def parse_fields(parsed_data, uploaded_count)
    parsed_data['fields'].each do |field_item|
      begin
        Field.find_or_create_by(name: field_item['name'], shape: "POLYGON ((#{field_item['polygon']}))")
        uploaded_count = uploaded_count + 1
      rescue Exception => exception
        logger.error "Couldn't add field: " + exception.message
      end
    end
  end

  def parse_records(parsed_data, uploaded_count)
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
  end
end
