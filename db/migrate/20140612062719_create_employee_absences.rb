class CreateEmployeeAbsences < ActiveRecord::Migration
  def change
    create_table :employee_absences do |t|
      t.date :date
      t.string :reason
      t.integer :employee_id
      t.timestamps
    end
  end
end
