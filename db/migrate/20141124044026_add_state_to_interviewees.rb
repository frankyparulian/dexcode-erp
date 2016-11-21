class AddStateToInterviewees < ActiveRecord::Migration
  def change
    add_column :interviewees, :state, :string
  end
end
