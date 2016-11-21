class ChangeDefaultValueForIntervieweesState < ActiveRecord::Migration
  def change
    change_column :interviewees, :state, :string, default: 'scheduled'
  end
end
