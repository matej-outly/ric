class CreateRicWebsiteTextAttachments < ActiveRecord::Migration
	def change
		create_table :text_attachments do |t|

			t.timestamps null: true

			# File
			t.attachment :file

			# Kind
			t.string :kind
		end
	end
end
