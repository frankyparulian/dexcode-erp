# == Schema Information
#
# Table name: companies
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  user_id    :integer
#

class Company < ActiveRecord::Base
  belongs_to :user
  has_many :employees, dependent: :destroy
  has_many :expenses, dependent: :destroy
  has_many :clients, dependent: :destroy
  has_many :invoices, dependent: :destroy
  has_many :holidays, dependent: :destroy
  has_many :interviews, dependent: :destroy
end
