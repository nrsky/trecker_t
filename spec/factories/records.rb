# == Schema Information
#
# Table name: collections
#
#  id             :integer       not null, primary key
#  driver_id      :integer       not null
#  company_id      :integer       not null
#  timestamp      :timestamp     not null
#  latitude       :float         not null
#  longitude      :float         not null
#  accuracy
#  speed
#  created_at     :timestamp
#  updated_at     :timestamp


FactoryGirl.define do
  factory :record do
    timestamp { Time.now }
    latitude { 52.234234 }
    longitude { 13.23324 }
    accuracy { 12.0 }
    speed { 123.45 }
    association :driver, factory: :driver
  end
end
