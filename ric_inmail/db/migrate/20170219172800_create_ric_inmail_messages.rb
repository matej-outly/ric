class CreateRicInmailMessages < ActiveRecord::Migration
	def change
		create_table :messages do |t|

			# Timestamps
			t.timestamps null: false

			# Ownership
			t.integer :owner_id, index: true
			t.string :folder, index: true

			# Sender
			t.integer :sender_id, index: true
			
			# Content
			t.string :subject
			t.text :message

			# States
			t.string :delivery_state, index: true
			t.boolean :is_read, index: true
			t.boolean :is_flagged
			t.boolean :is_replied
			t.boolean :is_forwarded

		end
	end
end
