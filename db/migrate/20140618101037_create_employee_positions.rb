class CreateEmployeePositions < ActiveRecord::Migration
  def change
    create_table :employee_positions do |t|
      t.string :position
    end

    add_column :employees, :employee_position_id, :string
  end
end
