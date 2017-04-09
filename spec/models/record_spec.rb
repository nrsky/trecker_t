require 'rails_helper'

RSpec.describe Record do
  subject { Record }

  it 'should raise validation exception when create with nil values' do
    expect{
      subject.create!
    }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Driver can't be blank, Timestamp can't be blank, Latitude can't be blank, Longitude can't be blank")
  end
end
