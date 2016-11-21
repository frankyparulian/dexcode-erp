class RenameSalarySens < ActiveRecord::Migration
  def change
    rename_column :employees, :salary_sens, :salary
  end
end
