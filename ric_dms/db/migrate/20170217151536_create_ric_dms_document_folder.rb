class CreateRicDmsDocumentFolder < ActiveRecord::Migration
	def change
		create_table :document_folders do |t|

			# Timestamps
			t.timestamps null: true

			# Hierarchical ordering
			t.integer :parent_id, null: true, index: true
			t.integer :lft, null: false, index: true
			t.integer :rgt, null: false, index: true
			t.integer :depth, null: false, default: 0

			# Additional info
			t.string :ref, index: true
			t.string :name
			t.text :description

		end
	end
end
