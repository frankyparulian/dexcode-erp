# == Schema Information
#
# Table name: invites
#
#  id          :integer          not null, primary key
#  employee_id :integer
#  email       :string(255)
#  code        :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :invite do
    employee_id 1
    email "MyString"
    code "MyString"
  end
end
