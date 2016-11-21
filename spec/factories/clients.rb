# == Schema Information
#
# Table name: clients
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  start_date      :date
#  end_date        :date
#  created_at      :datetime
#  updated_at      :datetime
#  company_id      :integer
#  billing_address :text
#  code            :string(255)
#  email           :string(255)      not null
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :client do
    company
    code 'CT'
  end
end
