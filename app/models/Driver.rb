# == Schema Information
#
# Table name: collections
#
#  id                        :integer          not null, primary key\
#  name                      :string(255)      not null
#  Originally it should be first name, last name, profile, etc, but let's simplify

class Driver < ApplicationRecord
  #Assumption that driver can work only for one company
  belongs_to :company
end
