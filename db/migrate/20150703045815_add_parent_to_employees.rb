class AddParentToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :parent, :integer
    add_index :employees, [:parent]
  end
end
