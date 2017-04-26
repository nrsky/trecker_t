require './app/services/driver_activity_calculation'
require 'rails_helper'

@elasticsearch
describe DriverActivityCalculation do
  let!(:driver){FactoryGirl.create(:driver)}
  let!(:field){FactoryGirl.create(:field)}

  subject {DriverActivityCalculation.new}

  context '#activities_for' do
    it 'should calculate type of activity and processing time' do
      10.times do
        Record.create(company_id: 1,
                      driver_id: driver.id,
                      timestamp:  Time.at((45.seconds.ago.to_f - 30.seconds.ago.to_f)*rand + 30.seconds.ago.to_f),
                      latitude: rand(29.0001...29.1001),
                      longitude: rand(77.0001...77.1001))

      end

      expect(Record.all.count).to eq(10)
      result = subject.activities_for(driver.id, Date.today, Field.all.map(&:shape))
      expect(result).to include("cultivating")
      expect(result).to include("driving")
      expect(result).to include("repairing")
    end
  end
end
