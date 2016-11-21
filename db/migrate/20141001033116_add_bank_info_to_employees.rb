class AddBankInfoToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :bank_name, :string
    add_column :employees, :bank_account_number, :string
  end
end
