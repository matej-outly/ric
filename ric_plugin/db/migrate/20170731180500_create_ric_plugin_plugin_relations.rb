class CreateRicPluginPluginRelations < ActiveRecord::Migration
	def change
		create_table :plugin_relations do |t|
			
			# Timestamps
			t.timestamps null: true
			
			# Kind
			t.string :kind, index: true
			
			# Associations
			t.integer :actor_id, index: true
			t.integer :actee_id, index: true

		end
	end
end
