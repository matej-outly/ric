class CreateRicInmailMessageReceivers < ActiveRecord::Migration
	def change
		create_table :message_receivers do |t|

			# Timestamps
			t.timestamps null: false

			# Message
			t.integer :message_id, index: true
			
			# Reciever
			t.integer :receiver_id, index: true
			
		end
	end
end
