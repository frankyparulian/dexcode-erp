class EditColumnTotalFromExpenses < ActiveRecord::Migration
  def change
    change_column :expenses, :total, :integer, default: 0, null: false
  end
end
