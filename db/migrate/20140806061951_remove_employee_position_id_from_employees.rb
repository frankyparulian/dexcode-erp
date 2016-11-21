class RemoveEmployeePositionIdFromEmployees < ActiveRecord::Migration
  def change
    remove_column :employees, :employee_position_id, :string
  end
end
