class CreateRicWebsiteTexts < ActiveRecord::Migration
	def change
		create_table :texts do |t|

			t.timestamps null: true
			
			# Identification
			t.string :key

			# Content
			t.string :title
			t.text :content

		end
	end
end
