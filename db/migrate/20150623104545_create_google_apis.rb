class CreateGoogleApis < ActiveRecord::Migration
  def change
    create_table :google_apis do |t|
    	t.text :client_id
    	t.text :client_secret
    	t.string :redirect_uri
      t.text :access_token
      t.integer :expire_in
      t.text :id_token
      t.text :refresh_token

      t.timestamps
    end
  end
end
