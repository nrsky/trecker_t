require 'rails_helper'

RSpec.describe Field do
  context "should have valid attributes" do

    subject { Field }

    it 'should create a field model with name ad geo-shape polygon' do
      field = subject.create(name: 'name', shape: "POLYGON ((75.15 29.53,77 29,77.6 29.5,75.15 29.53))")
      expect(field.name).to be_a String
      expect(field.shape.geometry_type.type_name).to eq("Polygon")
    end

    it 'should raise validation exception when create with nil values' do
      expect{
        subject.create!(name: 'name')
      }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Shape cannot be empty or the data is not a polygon")

      expect{
        subject.create!(shape: "POLYGON ((75.15 29.53,77 29,77.6 29.5,75.15 29.53))")
      }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Name can't be blank")
    end
  end
end
