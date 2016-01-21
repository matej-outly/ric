class CreateRicNotificationNotificationReceivers < ActiveRecord::Migration
	def change
		create_table :notification_receivers do |t|

			# Timestamps
			t.timestamps null: true
			t.datetime :sent_at
			t.datetime :received_at

			# Relations
			t.integer :notification_id
			t.integer :user_id

			# State
			t.string :state
		end
	end
end
