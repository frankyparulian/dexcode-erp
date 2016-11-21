class CreateEmployees < ActiveRecord::Migration
  def change
    create_table :employees do |t|
      t.string :name
      t.string :position
      t.money :salary
      t.timestamps
    end
  end
end
