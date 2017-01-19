class CreateRicWebsiteStructures < ActiveRecord::Migration
	def change
		create_table :structures do |t|
			t.timestamps null: true
			
			t.string :ref, index: true
			t.string :name
			t.string :description
			t.string :icon
			
			# Predicates
			t.boolean :show_in_navigation, index: true
			t.boolean :is_navigable, index: true
			t.boolean :has_pictures
			t.boolean :has_attachments
		end
	end
end
