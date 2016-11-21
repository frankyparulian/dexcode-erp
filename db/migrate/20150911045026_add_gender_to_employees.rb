class AddGenderToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :gender, :integer
  end
end
