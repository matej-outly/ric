class CreateRicUrlSlugs < ActiveRecord::Migration
	def change
		create_table :slugs do |t|
			t.timestamps null: true
			t.string :slug_locale, index: true
			t.string :original, index: true
			t.string :translation, index: true
		end
	end
end
