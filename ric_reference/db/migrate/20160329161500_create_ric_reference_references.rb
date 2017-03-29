class CreateRicReferenceReferences < ActiveRecord::Migration
	def change
		create_table :references do |t|

			t.timestamps null: true
			
			# Position
			t.integer :position, index: true
			
			# Name
			t.string :name

			# Localized name
			#t.string :name_cs
			#t.string :name_en
			
			# URL
			t.string :url

			# Image
			t.attachment :logo
		end
	end
end
