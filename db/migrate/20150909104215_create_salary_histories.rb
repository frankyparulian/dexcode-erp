class CreateSalaryHistories < ActiveRecord::Migration
  def change
    create_table :salary_histories do |t|
      t.references :employee, index: true, foreign_key: true
      t.float :salary, default: 0, null: false
      t.string :salary_currency, default: "IDR", null: false

      t.timestamps
    end
  end
end
