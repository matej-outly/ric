class CreateRicWebsiteSlugs < ActiveRecord::Migration
	def change
		create_table :slugs do |t|
			
			t.timestamps null: true

			t.string :slug_language
			t.string :original
			t.string :translation

		end
	end
end
