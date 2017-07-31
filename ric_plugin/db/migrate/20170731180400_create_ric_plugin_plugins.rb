class CreateRicPluginPlugins < ActiveRecord::Migration
	def change
		create_table :plugins do |t|
			
			# Timestamps
			t.timestamps null: true
			
			# Identification
			t.string :ref, index: true
			t.string :name

		end
		create_table :plugins_subjects, id: false do |t|
			
			# Associations
			t.integer :plugin_id, index: true
			t.integer :subject_id, index: true

		end
	end
end
