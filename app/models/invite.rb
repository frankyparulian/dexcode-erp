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

class Invite < ActiveRecord::Base
  validates :employee_id, presence: true
  validates :email, presence: true
  validates :code, presence: true

  belongs_to :employee
end
