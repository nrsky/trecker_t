require 'rails_helper'

RSpec.describe Company do
  context "should have valid attributes" do

    subject { Company }

    it 'should raise validation exception when create with nil values' do
      expect{
        subject.create!
      }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Name can't be blank")
    end
  end
end
