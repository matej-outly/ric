class CreateDocumentFolder < ActiveRecord::Migration
	def change
		create_table :document_folders do |t|

			# Timestamps
			t.timestamps null: true

			# Folder name
			t.string :name

			# Tree attributes
			t.integer :parent_id, index: true
			t.integer :lft
			t.integer :rgt, index: true
			t.integer :depth

		end
	end
end
