# Store the invoice documents
class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.string :document, null: false
      t.references :documentable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
