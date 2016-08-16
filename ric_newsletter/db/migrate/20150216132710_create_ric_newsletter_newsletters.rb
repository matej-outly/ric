class CreateRicNewsletterNewsletters < ActiveRecord::Migration
	def change
		create_table :newsletters do |t|

			# Timestamps
			t.timestamps null: true

			# Content
			t.string :subject
			t.text :content

		end
	end
end
