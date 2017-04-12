class CreateRicNotificationNotifications < ActiveRecord::Migration
	def change
		create_table :notifications do |t|

			# Timestamps
			t.timestamps null: true
			t.datetime :sent_at

			# Kind
			t.string :kind

			# Message
			t.string :subject
			t.text :message

			# Attachments
			t.string :url
			t.string :attachment

			# Sender
			t.integer :sender_id, index: true
			t.string :sender_type, index: true

			# Statistics
			t.integer :receivers_count
			t.integer :sent_count

		end
	end
end
