class RemoveRoleFromEmployees < ActiveRecord::Migration
  def change
    remove_column :employees, :role, :string
  end
end
