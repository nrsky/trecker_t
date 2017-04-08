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

  if Field.all.empty?
    file_path = File.join(Rails.root, 'spec', 'fixtures', 'fields.json')
    ParserService.new.upload_fields_from(File.read(file_path))
  end
end

#seeds for production environment
if Rails.env.production?
  # production specific seeding code
end
