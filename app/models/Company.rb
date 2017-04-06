# == Schema Information
#
# Table name: collections
#
#  id                        :integer          not null, primary key
#  name                      :string(255)      not null

class Company < ApplicationRecord
  has_many :drivers
  #Assumption that the company has a list of fields where they provide their services
  has_and_belongs_to_many :fields
end
