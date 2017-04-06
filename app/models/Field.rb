# == Schema Information
#
# Table name: collections
#
#  id                        :integer          not null, primary key
#  name                      :string(255)      not null
#  position                  :integer          geocode

class Field < ApplicationRecord
  #Assumption that many companies may providing works on the field
  has_and_belongs_to_many :companies
end
