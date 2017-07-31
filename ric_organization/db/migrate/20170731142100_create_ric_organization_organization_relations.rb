class CreateRicOrganizationOrganizationRelations < ActiveRecord::Migration
	def change
		create_table :organization_relations do |t|

			t.timestamps null: true
			
			# Actor and actee
			t.integer :actor_id, index: true
			t.integer :actee_id, index: true

			# Kind
			t.string :kind

		end
	end
end
