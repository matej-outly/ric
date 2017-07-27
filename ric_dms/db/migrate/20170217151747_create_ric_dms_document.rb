class CreateRicDmsDocument < ActiveRecord::Migration
	def change
		create_table :documents do |t|

			# Timestamps
			t.timestamps null: true
			
			# Folder
			t.integer :document_folder_id, index: true

			# Additional info
			t.string :name
			t.text :description

		end

		# Documents in one folder must have unique names
		add_index :documents, [:name, :document_folder_id], unique: true

	end
end
