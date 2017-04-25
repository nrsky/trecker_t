require './app/services/driver_activity_service'
require 'rails_helper'

describe DriverActivityService do
  let!(:driver){FactoryGirl.create(:driver)}
  let!(:field){FactoryGirl.create(:field)}

  subject {DriverActivityService.new}

  context '#activities_for' do
    #TODO move to features for controller
    it 'should calculate type of activity and processing time' do
      repository = Elasticsearch::Persistence::Repository.new


      #clean elastic search  before each test
      10.times do
        record = Record.create(company_id: 1,
                               driver_id: driver.id,
                               timestamp:  Time.at((45.seconds.ago.to_f - 30.seconds.ago.to_f)*rand + 30.seconds.ago.to_f),
                               latitude: rand(29.0001...29.1001),
                               longitude: rand(77.0001...77.1001))
        record.save
        repository.save(record)
      end
      result = subject.activities_for(617, Date.today)
      #expect result, etc. Should be moved to cucumber feature to test full json response
    end

    it 'should get correct distance between two points' do
      #TODO move to configs
      Geocoder.configure(:units => :km)
      expect(subject.send(:get_distance, 29.0001,  77.0001, 29.0101, 77.0101)).to eq(1.4772128353785692)
    end


    it 'should return if point is included into one of the fields' do
      #TODO Should be tested better.
      # Ok, I just know from other services that this is correct for this polygon field: "75.15 29.53,77 29,77.6 29.5,75.15 29.53"
      expect(subject.send(:part_of_fields?, Field.all.map(&:shape), 77.010, 29.010)).to eq(true)
      expect(subject.send(:part_of_fields?, Field.all.map(&:shape), 29.0001, 77.0001)).to eq(false)
    end

    it 'should calculate time difference in seconds' do
      expect(subject.send(:get_time,  Time.now, 1.minute.ago).to_i).to eq(59)
    end
  end
end
