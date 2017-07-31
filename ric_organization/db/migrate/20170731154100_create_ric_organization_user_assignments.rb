class CreateRicOrganizationUserAssignments < ActiveRecord::Migration
	def change
		create_table :user_assignments do |t|

			t.timestamps null: true

			# Relations
			t.integer :organization_id, index: true
			t.integer :user_id, index: true
			t.integer :organization_assignment_id, index: true
			
		end
	end
end
