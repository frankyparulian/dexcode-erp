class AddBillingAddressToClients < ActiveRecord::Migration
  def change
    add_column :clients, :billing_address, :text
  end
end
