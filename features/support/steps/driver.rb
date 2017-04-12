Given(/^a driver with id (\d+)$/) do |id|
  @driver = given_a_driver(id: id)
end

def given_a_driver(id: id)
  Driver.create!(id: id, name: Faker::Name.name)
end
