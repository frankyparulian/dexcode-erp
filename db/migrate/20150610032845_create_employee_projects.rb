# Create table for employee and project table relation
class CreateEmployeeProjects < ActiveRecord::Migration
  def change
    create_table :employee_projects do |t|
      t.integer :employee_id, null: false
      t.integer :project_id, null: false

      t.timestamps
    end
  end
end
