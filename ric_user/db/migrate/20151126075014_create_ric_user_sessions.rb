class CreateRicUserSessions < ActiveRecord::Migration
	def change
		create_table :sessions, id: false do |t|

			# Timestamps
			t.timestamps null: true

			# ID
			t.string :id, null: false

		end

		# Index
		add_index :sessions, :id, unique: true
	end
end
