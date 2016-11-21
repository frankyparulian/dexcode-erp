class CleanupHolidays < ActiveRecord::Migration
  def up
    Holiday.find_each do |holiday|
      holiday.destroy unless holiday.company.present?
    end
  end

  def down

  end
end
