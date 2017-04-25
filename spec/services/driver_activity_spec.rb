require './app/services/driver_activity'
require 'rails_helper'

@elasticsearch
describe DriverActivity do
  let!(:driver){FactoryGirl.create(:driver)}
  let!(:field){FactoryGirl.create(:field)}

  subject {DriverActivity.new}

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
      #TODO expect result
      result = subject.activities_for(driver.id, Date.today)
    end
  end
end
