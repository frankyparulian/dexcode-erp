# == Schema Information
#
# Table name: employee_absences
#
#  id            :integer          not null, primary key
#  date          :date
#  reason        :string(255)
#  employee_id   :integer
#  created_at    :datetime
#  updated_at    :datetime
#  use_sick_days :boolean
#

class EmployeeAbsence < ActiveRecord::Base
  belongs_to :employee

  validates :date, presence: true
  validates :reason, presence: true
  validates :employee_id, presence: true
end
