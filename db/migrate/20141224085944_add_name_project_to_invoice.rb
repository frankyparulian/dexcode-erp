class AddNameProjectToInvoice < ActiveRecord::Migration
  def change
    add_column :invoices, :name_project, :string
  end
end
