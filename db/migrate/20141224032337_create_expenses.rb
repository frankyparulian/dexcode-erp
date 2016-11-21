class CreateExpenses < ActiveRecord::Migration
  def change
    create_table :expenses do |t|
      t.string    :name
      t.integer   :total
      t.date      :date
      t.timestamps
    end
  end
end
