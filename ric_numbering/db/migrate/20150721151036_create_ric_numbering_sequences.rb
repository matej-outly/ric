class CreateRicNumberingSequences < ActiveRecord::Migration
	def change
		create_table :sequences do |t|
			t.timestamps null: true
			
			# Owner
			t.integer :owner_id, index: true
			t.string :owner_type, index: true
			
			# Identification
			t.string  :ref, index: true

			# Scope
			t.integer :scope_id, index: true
			t.string  :scope_type, index: true
			t.string  :scope_string, index: true

			# Current number
			t.integer :current, limit: 8
		end
	end
end
