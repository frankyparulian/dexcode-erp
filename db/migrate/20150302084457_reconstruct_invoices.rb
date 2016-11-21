class ReconstructInvoices < ActiveRecord::Migration
  def change
    drop_table :invoices
    create_table :invoices do |t|
      t.integer :client_id
      t.integer :company_id
      t.float   :subtotal
      t.float   :tax_percent
      t.float   :tax_amount
      t.float   :total
      t.date    :begin_date
      t.date    :end_date
      t.timestamps
    end
  end
end
