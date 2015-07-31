class CreateRicJournalNewies < ActiveRecord::Migration
	def change
		create_table :newies do |t|

			t.timestamps null: true

			t.datetime :published_at
			t.string :title
			t.text :perex
			t.text :content
		end
	end
end
