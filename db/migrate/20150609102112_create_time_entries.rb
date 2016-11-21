# Create TimeEntries table
class CreateTimeEntries < ActiveRecord::Migration
  def change
    create_table :time_entries do |t|
      t.integer :employee_id, null: false
      t.integer :project_id, null: false
      t.float :hours, null: false
      t.date :date, null: false

      t.timestamps
    end
  end
end
