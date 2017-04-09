require 'rails_helper'

RSpec.describe RecordIndex do
  context "should create valid index" do
    let(:record) {FactoryGirl.build(:record)}

    it 'should add index to elastic search after model creation' do
      expect{ record.save! }.to  update_index('record#record')
    end
  end
end
