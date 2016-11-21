# == Schema Information
#
# Table name: employees
#
#  id                  :integer          not null, primary key
#  name                :string(255)
#  position            :string(255)
#  salary              :integer          default(0), not null
#  salary_currency     :string(255)      default("IDR"), not null
#  created_at          :datetime
#  updated_at          :datetime
#  start_date          :date
#  end_date            :date
#  ktp                 :string(255)
#  user_id             :integer
#  company_id          :integer
#  bank_name           :string(255)
#  bank_account_number :string(255)
#  photo               :string(255)
#  bank_account_holder :string(255)
#  ancestry            :string(255)
#  parent              :integer
#  no_npwp             :string(255)
#  status              :integer
#  child               :integer
#  gender              :integer
#  date_of_birth       :date
#
# Indexes
#
#  index_employees_on_ancestry  (ancestry)
#  index_employees_on_parent    (parent)
#

FactoryGirl.define do
  factory :employee do
    user
    company
    position "Dummy Position"
    start_date { Date.today }
    sequence(:name)     { |n| "Employee #{n}"}
  end
end
