class AddChildrenToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :child, :integer
  end
end
