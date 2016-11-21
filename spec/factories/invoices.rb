# == Schema Information
#
# Table name: invoices
#
#  id                  :integer          not null, primary key
#  client_id           :integer
#  company_id          :integer
#  subtotal            :float
#  tax_percent         :float
#  tax_amount          :float
#  total               :float
#  begin_date          :date
#  end_date            :date
#  created_at          :datetime
#  updated_at          :datetime
#  number              :string(255)
#  payment_information :text
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :invoice do
    subtotal 0
    tax_percent 0
    tax_amount 0
    total 0
  end
end
