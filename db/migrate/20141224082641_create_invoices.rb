class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.integer     :client_id
      t.integer     :company_id
      t.integer     :total
      t.date        :begin_periode
      t.date        :end_periode
      t.timestamps
    end
  end
end
