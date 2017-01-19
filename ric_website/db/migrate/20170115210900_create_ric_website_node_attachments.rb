class CreateRicWebsiteNodeAttachments < ActiveRecord::Migration
	def change
		create_table :node_attachments do |t|
			t.timestamps null: true

			# Relation
			t.integer :node_id

			# Attachment
			t.attachment :attachment

			# Kind
			t.string :kind
		end
	end
end
