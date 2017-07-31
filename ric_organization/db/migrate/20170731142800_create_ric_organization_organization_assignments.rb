class CreateRicOrganizationOrganizationAssignments < ActiveRecord::Migration
	def change
		create_table :organization_assignments do |t|

			t.timestamps null: true

			# Organziation
			t.integer :organization_id, index: true
			
			# Name
			t.string :name

		end
	end
end
