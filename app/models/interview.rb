# == Schema Information
#
# Table name: interviews
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  schedule   :datetime
#  created_at :datetime
#  updated_at :datetime
#  state      :string(255)      default("scheduled")
#  company_id :integer
#

class Interview < ActiveRecord::Base
  validates :name, presence: true
  validates :email, presence: true
  validates :schedule, presence: true
  validates :state, format: { with: /\A(noshow|scheduled|hired|rejected)\z/ }
  belongs_to :company
end
