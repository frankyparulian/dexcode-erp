# Create Projects table
class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.integer :client_id, null: false
      t.string :name, null: false

      t.timestamps
    end
  end
end
