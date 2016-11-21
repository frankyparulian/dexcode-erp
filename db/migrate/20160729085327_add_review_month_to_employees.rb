class AddReviewMonthToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :review_month, :integer, limit: 1
  end
end
