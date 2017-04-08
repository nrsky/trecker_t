# == Schema Information
#
# Table name: collections
#
#  id             :integer   not null, primary key
#  driver_id      :integer   not null
#  timestamp
#  latitude
#  longitude
#  accuracy
#  speed

class Record < ApplicationRecord
  belongs_to :driver
end
