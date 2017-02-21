class CreateDocumentVersion < ActiveRecord::Migration
	def change
		create_table :document_versions do |t|

			# Timestamps
			t.timestamps null: true

			# Associated document
			t.integer :document_id, index: true

			# Attachment (file)
			t.attachment :attachment

		end
	end
end
