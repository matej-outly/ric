class CreateRicAuthAuthentications < ActiveRecord::Migration
	def change
		create_table :authentications do |t|
			
			# Timestamps
			t.timestamps null: true

			# Relation to user
			t.integer :user_id, index: true

			# OmniAuth
			t.string :provider, index: true
			t.string :uid, index: true
			t.string :oauth_token
			t.datetime :oauth_expires_at

		end
	end
end
