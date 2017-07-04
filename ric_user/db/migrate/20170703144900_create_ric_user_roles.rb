class CreateRicUserSessions < ActiveRecord::Migration
	def change
		create_table :roles do |t|

			# Timestamps
			t.timestamps null: true

			# ID
			t.string :ref, index: true

			# Human readable ID
			t.string :name
			t.text :description

			# Default flags
			t.boolean :default_signed, index: true
			t.boolean :default_unsigned, index: true
			
		end
	end
end
