class CreateRicNotificationNotifications < ActiveRecord::Migration
	def change
		create_table :notifications do |t|

			# Timestamps
			t.timestamps null: true

			# Kind
			t.string :kind

			# Message
			t.string :subject
			t.text :message
			t.string :url

			# Author (user)
			t.integer :author_id

		end
	end
end
