class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.integer :employee_id
      t.string :email
      t.string :code

      t.timestamps
    end
  end
end
