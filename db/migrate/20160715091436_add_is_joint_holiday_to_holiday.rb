class AddIsJointHolidayToHoliday < ActiveRecord::Migration
  def change
    add_column :holidays, :is_joint_holiday, :boolean
  end
end
