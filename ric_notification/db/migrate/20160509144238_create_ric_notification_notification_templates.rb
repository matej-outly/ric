class CreateRicNotificationNotificationTemplates < ActiveRecord::Migration
	def change
		create_table :notification_templates do |t|

			# Timestamps
			t.timestamps null: true
			
			# Identification
			t.string :key
			t.string :description

			# Message
			t.text :message
			
		end
	end
end
