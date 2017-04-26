if Rails.env.development?
  if Company.all.empty?
    20.times do
      Company.create(name: Faker::Company.name)
    end
  end

  company_ids = Company.all.map(&:id)

  if Driver.all.empty?
    50.times do
      Driver.create(name: Faker::Name.name, company_id: company_ids[rand(0..company_ids.count)])
    end
  end

  Elasticsearch::Persistence.client.indices.create(index: 'records') unless Elasticsearch::Persistence.client.indices.exists? index: 'records'

  if Record.all.empty?
    driver_ids = Driver.all.map(&:id)
    #Generating with random lat and long( almost 100% not in test data polygons )
    100.times do
      Record.create(driver_id: driver_ids[rand(0..driver_ids.count-1)],
                    company_id: company_ids[rand(0..company_ids.count)],
                    accuracy: rand(0.0..15.0),
                    speed: rand(0..150.0),
                    timestamp:  Time.at((45.minutes.ago.to_f - 30.minutes.ago.to_f)*rand + 30.minutes.ago.to_f),
                    latitude: rand(90.0...91.0),
                    longitude: rand(10.0...11.0)
      )
      end
    #Generating with lat and long which are in this Polygon "polygon":"75.15 29.53,77 29,77.6 29.5,75.15 29.53"
    10000.times do
      Record.create(driver_id: driver_ids[rand(0..driver_ids.count-1)],
                    company_id: company_ids[rand(0..company_ids.count)],
                    accuracy: rand(0.0..15.0),
                    speed: rand(0..150.0),
                    timestamp:   Time.at((35.minutes.ago.to_f - 33.minutes.ago.to_f)*rand + 33.minutes.ago.to_f),
                    latitude: rand(29.0001...29.1001),
                    longitude: rand(77.0001...77.1001)
      )
    end
    # Elasticsearch::Persistence.client.indices.refresh index: 'records'
  end

  if Field.all.empty?
    file_path = File.join(Rails.root, 'spec', 'fixtures', 'fields.json')
    JsonParser.new.upload_fields_from(File.read(file_path))
  end
end

#seeds for production environment
if Rails.env.production?
  # production specific seeding code
end
