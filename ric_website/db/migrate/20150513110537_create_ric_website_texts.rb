class CreateRicWebsiteTexts < ActiveRecord::Migration
	def change
		create_table :texts do |t|

			t.timestamps null: true
			
			# Identification
			t.string :key

			# Content
			t.string :title
			t.text :content

			# Localized content
			#t.string :title_cs
			#t.string :title_en
			#t.text :content_cs
			#t.text :content_en

		end
	end
end
