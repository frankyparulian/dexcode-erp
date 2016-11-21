class AddBankCodeToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :bank_code, :string
  end
end
