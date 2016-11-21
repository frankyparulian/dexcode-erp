class AddNoNpwpToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :no_npwp, :string
  end
end
