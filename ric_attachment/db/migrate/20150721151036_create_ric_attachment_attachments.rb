class CreateRicAttachmentAttachments < ActiveRecord::Migration
	def change
		create_table :attachments do |t|
			t.timestamps null: true
			t.integer :subject_id, index: true
			t.string :subject_type, index: true
			t.attachment :file
			t.string :kind, index: true
			t.string :session_id, index: true
		end
	end
end
