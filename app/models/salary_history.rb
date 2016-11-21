# == Schema Information
#
# Table name: salary_histories
#
#  id              :integer          not null, primary key
#  employee_id     :integer
#  salary          :float            default(0.0), not null
#  salary_currency :string(255)      default("IDR"), not null
#  created_at      :datetime
#  updated_at      :datetime
#
# Indexes
#
#  index_salary_histories_on_employee_id  (employee_id)
#

class SalaryHistory < ActiveRecord::Base
  belongs_to :employee
end
