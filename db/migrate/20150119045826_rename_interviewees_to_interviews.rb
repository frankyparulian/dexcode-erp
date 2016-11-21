class RenameIntervieweesToInterviews < ActiveRecord::Migration
  def change
    rename_table :interviewees, :interviews
  end
end
