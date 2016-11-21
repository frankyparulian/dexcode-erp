# Create a Feedback table
class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.string :gid
      t.integer :client_id
      t.string :client_name
      t.string :content
      t.float :rating
      t.boolean :allow_publish

      t.timestamps
    end
  end
end
