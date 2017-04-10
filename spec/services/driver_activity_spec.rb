require './app/services/driver_activity_service'
require 'rails_helper'

describe DriverActivityService do
  let!(:driver){FactoryGirl.create(:driver)}
  let!(:field){FactoryGirl.create(:field)}

  subject {DriverActivityService.new}

  context '#activities_for' do
    #TODO move to features for controller
    it 'should calculate type of activity and processing time' do
      10.times do
        FactoryGirl.create(:record,
                           driver: driver,
                           timestamp:  Time.at((45.seconds.ago.to_f - 30.seconds.ago.to_f)*rand + 30.seconds.ago.to_f),
                           latitude: rand(29.0001...29.1001),
                           longitude: rand(77.0001...77.1001))
      end
      RecordIndex.reset!
      expect(RecordIndex::Record.query(term: {driver_id: driver.id}).total_count).to eq(10)
      hash = subject.activities_for(driver.id, 1.day.ago, Time.now)
      expect(hash[:driving_time]).to be_truthy
      expect(hash[:cultivating_time]).to be_truthy
      expect(hash[:reparing_time]).to be_truthy
    end

    it 'should get correct distance between two points' do
      location1 = {"lon": 29.0001, "lat": 77.0001}.stringify_keys!
      location2 = {"lon": 29.0101, "lat": 77.0101}.stringify_keys!
      expect(subject.send(:get_distance, location1, location2)).to eq(1.4772128353785692)
    end


    it 'should return if point is included into one of the fields' do
      #TODO Should be tested better.
      # Ok, I just know from other services that this is correct for this polygon field: "75.15 29.53,77 29,77.6 29.5,75.15 29.53"
      expect(subject.send(:part_of_fields?, RGeo::Geographic.spherical_factory, Field.all.map(&:shape), 77.010, 29.010)).to eq(true)
      expect(subject.send(:part_of_fields?, RGeo::Geographic.spherical_factory, Field.all.map(&:shape), 29.0001, 77.0001)).to eq(false)
    end

    it 'should calculate processed time for activities' do
      processing_time = {driving_time: 0, cultivating_time: 0, reparing_time: 0}
      expect{subject.send(:update_processing_time!,processing_time, 4.7, 4, true)}.to change{processing_time}.to({driving_time: 0, cultivating_time: 4, reparing_time: 0})
      expect{subject.send(:update_processing_time!,processing_time, 4.7, 4, false)}.not_to change{processing_time}
      expect{subject.send(:update_processing_time!,processing_time, 5.1, 4, false)}.to change{processing_time}.to({driving_time: 4, cultivating_time: 4, reparing_time: 0})
      expect{subject.send(:update_processing_time!,processing_time, 5.1, 4, true)}.not_to change{processing_time}
      expect{subject.send(:update_processing_time!,processing_time, 0.1, 4, true)}.to change{processing_time}.to({driving_time: 4, cultivating_time: 4, reparing_time: 4})
      expect{subject.send(:update_processing_time!,processing_time, 0.1, 4, false)}.not_to change{processing_time}
    end

    it 'should calculate time difference in seconds' do
      expect(subject.send(:get_time, 1.minute.ago.to_s, Time.now.to_s)).to eq(60)
    end
  end
end
