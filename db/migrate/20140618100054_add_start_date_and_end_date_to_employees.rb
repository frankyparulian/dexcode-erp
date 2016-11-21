class AddStartDateAndEndDateToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :start_date, :date
    add_column :employees, :end_date, :date
    add_column :employees, :ktp, :string
  end
end
