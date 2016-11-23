class CreateRicUrlSlugs < ActiveRecord::Migration
	def change
		create_table :slugs do |t|
			t.timestamps null: true
			t.string :locale, index: true
			# t.string :web_filter, index: true # Optional column distinguishing website by reference string
			t.string :original, index: true
			t.string :translation, index: true
		end
	end
end
