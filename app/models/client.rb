# == Schema Information
#
# Table name: clients
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)      not null
#  start_date      :date
#  end_date        :date
#  created_at      :datetime
#  updated_at      :datetime
#  company_id      :integer
#  billing_address :text
#  code            :string(255)
#

class Client < ActiveRecord::Base
  belongs_to :company
  has_many :invoices
  has_many :projects

  validates :code, presence: true, uniqueness: { scope: [:company_id] }
  validates :email, presence: true
end
