class AddCompanyIdToInterviewee < ActiveRecord::Migration
  def change
    add_column :interviewees, :company_id, :integer
  end
end
