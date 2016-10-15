class CreateRicAssortmentProductAttachments < ActiveRecord::Migration
	def change
		create_table :product_attachments do |t|

			t.timestamps null: true
			
			# Position
			t.integer :position, index: true

			# Title
			t.string :title

			# File
			t.attachment :file

		end
		create_table :product_attachments_products, id: false do |t|

			t.timestamps null: true

			# Relations
			t.integer :product_id, index: true
			t.integer :product_attachment_id, index: true

		end
	end
end
