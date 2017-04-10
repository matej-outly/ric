class CreateRicBoardBoardTickets < ActiveRecord::Migration
	def change
		create_table :board_tickets do |t|

			# Timestamps
			t.timestamps null: true

			# Subject (polymorphic association)
			t.integer :subject_id
			t.string :subject_type

			# Key used for ticket kind identification
			t.string :key

			# Owner (polymorphic association)
			t.integer :owner_id
			t.string :owner_type

			# Is ticket closed?
			t.boolean :closed, index: true

			# Expiration date
			t.date :date, null: true, index: true

			# Occasion
			t.string :occasion

		end

		add_index :board_tickets, [:subject_id, :subject_type]
		add_index :board_tickets, [:owner_id, :owner_type]
		add_index :board_tickets, [:owner_id, :owner_type, :closed, :date], name: "index_board_tickets_on_owner_id_and_owner_type_closed_date"
	end
end


