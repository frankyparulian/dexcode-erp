class AddPaymentInformationToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :payment_information, :text
  end
end
