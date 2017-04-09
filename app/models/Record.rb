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

class Record < ApplicationRecord
  belongs_to :driver

  validates :driver_id, presence: true
  validates :timestamp, presence: true
  validates :latitude, presence: true
  validates :longitude, presence: true
end
