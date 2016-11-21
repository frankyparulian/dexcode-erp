# Add Email column to Clients table
class AddEmailToClients < ActiveRecord::Migration
  def change
    add_column :clients, :email, :string, null: false, after: :name
  end
end
