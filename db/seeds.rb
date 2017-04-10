#Seeds for development environment
if Rails.env.development?
  # development specific seeding code

  if Company.all.empty?
    20.times do
      Company.create(name: Faker::Company.name)
    end
  end
  if Driver.all.empty?
    company_ids = Company.all.map(&:id)
    50.times do
      Driver.create(name: Faker::Name.name, company_id: company_ids[rand(0..company_ids.count)])
    end
  end

  #TODO delete from migrations. This block is for compare how fast is it to push 100K data to Postgres and to ElasticSearch
  # For me at mac i7 it took 15 minutes to insert this data to postgres DB
  # it takes about 10 seconds to update indexes for the same amount.

  if Record.all.empty?
    Chewy.strategy(:atomic)
    driver_ids = Driver.all.map(&:id)
    #Generating with random lat and long( almost 100% not in test data polygons )
    100.times do
      Record.create!(driver_id: driver_ids[rand(0..driver_ids.count-1)],
                    accuracy: rand(0.0..15.0),
                    speed: rand(0..150.0),
                    timestamp:  Time.at((45.minutes.ago.to_f - 30.minutes.ago.to_f)*rand + 30.minutes.ago.to_f),
                    latitude: rand(90.0...91.0),
                    longitude: rand(10.0...11.0)
      )
      end
    #Generating with lat and long which are in this Polygon "polygon":"75.15 29.53,77 29,77.6 29.5,75.15 29.53"
    100000.times do
      Record.create!(driver_id: driver_ids[rand(0..driver_ids.count-1)],
                    accuracy: rand(0.0..15.0),
                    speed: rand(0..150.0),
                    timestamp:   Time.at((45.minutes.ago.to_f - 30.minutes.ago.to_f)*rand + 30.minutes.ago.to_f),
                    latitude: rand(77.0001...77.1001),
                    longitude: rand(29.0001...29.1001)
      )
    end
  end

  if Field.all.empty?
    file_path = File.join(Rails.root, 'spec', 'fixtures', 'fields.json')
    FileParserService.new.upload_fields_from(File.read(file_path))
  end
end

#seeds for production environment
if Rails.env.production?
  # production specific seeding code
end
