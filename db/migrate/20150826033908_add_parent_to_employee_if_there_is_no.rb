class AddParentToEmployeeIfThereIsNo < ActiveRecord::Migration
  def up
    Employee.reset_column_information
    unless Employee.column_names.include?('parent')
      add_column :employees, :parent, :integer
      add_index :employees, [:parent]
    end
  end
  def down
    Employee.reset_column_information
    unless Employee.column_names.include?('parent')
      remove_column :employees, :parent
    end
  end
end
