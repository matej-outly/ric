class CreateRicUserSessions < ActiveRecord::Migration
	def change
		create_table :sessions, id: false do |t|
			
			# ID
			t.string :id, null: false

			# Timestamps
			t.timestamps null: true

		end

		# Index
		add_index :sessions, :id, unique: true
	end
end
