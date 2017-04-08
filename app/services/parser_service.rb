class ParserService

  def upload_fields_from(file)
    parsed_data = JSON.parse(file)
    parsed_data['fields'].each do |field_item|
      field = Field.find_or_initialize_by(name: field_item['name'])
      field.shape = "POLYGON ((#{field_item['polygon']}))"
      field.save!
    end
  end
end
