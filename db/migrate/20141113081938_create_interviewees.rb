class CreateInterviewees < ActiveRecord::Migration
  def change
    create_table :interviewees do |t|
      t.string :name
      t.string :email
      t.datetime :schedule

      t.timestamps
    end
  end
end
