class CreateRicAclPrivileges < ActiveRecord::Migration
	def change
		create_table :privileges do |t|
			
			# Timestamps
			t.timestamps null: true

			# Owner
			t.integer :owner_id, index: true
			t.string :owner_type, index: true

			# Scope
			t.integer :scope_id, index: true
			t.string :scope_type, index: true
			t.string :scope_range, index: true

			# Subject
			t.integer :subject_id, index: true
			t.string :subject_type, index: true

			# Action
			t.string :action, index: true
			
		end
	end
end
