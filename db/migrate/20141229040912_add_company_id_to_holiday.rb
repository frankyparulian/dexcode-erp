class AddCompanyIdToHoliday < ActiveRecord::Migration
  def change
    add_column :holidays, :company_id, :integer
  end
end
