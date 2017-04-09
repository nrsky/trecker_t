# == Schema Information
#
# Table name: collections
#
#  id                        :integer          not null, primary key\
#  name                      :string(255)      not null
#  Originally it should be first name, last name, profile, etc, but let's simplify


FactoryGirl.define do
  factory :driver do
    name {Faker::Name.name}
  end
end
