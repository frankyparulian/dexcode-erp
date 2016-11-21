# == Schema Information
#
# Table name: expenses
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  total      :integer          default(0), not null
#  date       :date
#  created_at :datetime
#  updated_at :datetime
#  company_id :integer
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :expense do
  end
end
