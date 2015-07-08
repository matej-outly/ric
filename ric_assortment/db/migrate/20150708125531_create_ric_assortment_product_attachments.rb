class CreateRicAssortmentProductAttachments < ActiveRecord::Migration
	def change
		create_table :product_attachments do |t|

			t.timestamps null: true
			
			# Position
			t.integer :position

			# Title
			t.string :title

			# File
			t.attachment :file

		end
		create_table :product_attachments_products, id: false do |t|

			t.timestamps null: true

			# Bind
			t.integer :product_id
			t.integer :product_attachment_id

		end
	end
end
