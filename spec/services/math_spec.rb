require './app/services/driver_activity'
require 'rails_helper'

@elasticsearch
describe Trecker::Math do
  let!(:field){FactoryGirl.create(:field)}

  subject {Trecker::Math.instance}

  context '#activities_for' do
    it 'should get correct distance between two points' do
      expect(subject.send(:get_distance, 29.0001,  77.0001, 29.0101, 77.0101)).to eq(1.4772128353785692)
    end

    it 'should return if point is included into one of the fields' do
      #NOTE polygon  type example: "75.15 29.53,77 29,77.6 29.5,75.15 29.53"
      expect(subject.send(:part_of_fields?, Field.all.map(&:shape), 77.010, 29.010)).to eq(true)
      expect(subject.send(:part_of_fields?, Field.all.map(&:shape), 29.0001, 77.0001)).to eq(false)
    end

    it 'should calculate time difference in seconds' do
      expect(subject.send(:get_time,  Time.now, 1.minute.ago).to_i).to eq(59)
    end
  end
end
