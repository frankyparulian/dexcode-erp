class AddBankAccontHolderToEmployees < ActiveRecord::Migration
  def change
  	add_column :employees, :bank_account_holder, :string
  end
end
