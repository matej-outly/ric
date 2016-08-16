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
			t.string :url

			# Author (user)
			t.integer :author_id

			# Statistics
			t.integer :receivers_count
			t.integer :sent_count

		end
	end
end
