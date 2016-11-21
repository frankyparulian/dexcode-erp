class CreateInvoiceItems < ActiveRecord::Migration
  def change
    create_table :invoice_items do |t|
      t.integer :invoice_id
      t.string  :name
      t.float   :quantity
      t.float   :unit_price
      t.float   :amount
      t.string  :type
      t.timestamps
    end
  end
end
