Given(/^a driver with id (\d+)$/) do |id|
  @driver = given_a_driver(id: id)
end

Given(/^a field "(.*?)" with valid shape$/) do |name|
  @field = Field.find_or_create_by(name: name, shape: "POLYGON ((75.15 29.53,77 29,77.6 29.5,75.15 29.53))")
end

Given(/^records in elastic search with driver_id "(.*?)"$/) do |driver_id|
  10.times do
    Record.create(company_id: 1,
                  driver_id: driver_id,
                  timestamp:  Time.at((45.seconds.ago.to_f - 30.seconds.ago.to_f)*rand + 30.seconds.ago.to_f),
                  latitude: rand(29.0001...29.1001),
                  longitude: rand(77.0001...77.1001))

  end
end

def given_a_driver(id: id)
  Driver.create!(id: id, name: Faker::Name.name)
end
