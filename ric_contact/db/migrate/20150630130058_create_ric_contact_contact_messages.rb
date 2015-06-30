class CreateRicContactContactMessages < ActiveRecord::Migration
	def change
		create_table :contact_messages do |t|

			t.timestamps null: true

			# Content
			t.string :name
			t.string :email
			t.text :message
			
		end
	end
end
