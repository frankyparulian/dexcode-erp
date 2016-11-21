class AddUseSickDaysToEmployeeAbsences < ActiveRecord::Migration
  def change
    add_column :employee_absences, :use_sick_days, :boolean
  end
end
