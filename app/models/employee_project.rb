# == Schema Information
#
# Table name: employee_projects
#
#  id          :integer          not null, primary key
#  employee_id :integer          not null
#  project_id  :integer          not null
#  created_at  :datetime
#  updated_at  :datetime
#

# Store relation for employees and projects table
class EmployeeProject < ActiveRecord::Base
  validates :employee_id, presence: true
  validates :project_id, presence: true

  belongs_to :employee
  belongs_to :project
end
