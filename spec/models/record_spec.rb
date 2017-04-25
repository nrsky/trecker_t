require 'rails_helper'

RSpec.describe Record do
  subject { Record }

  it 'should raise validation exception when create with nil values' do
    record  = subject.create(speed: 123)
    expect(record.valid?).to be_falsey
    expect(record.errors.to_json).to eq("{\"company_id\":[\"can't be blank\"],\"longitude\":[\"can't be blank\"],\"latitude\":[\"can't be blank\"]}")
  end
end
