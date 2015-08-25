class CreateRicJournalNewiePictures < ActiveRecord::Migration
	def change
		create_table :newie_pictures do |t|

			t.timestamps null: true

			t.integer :position
			t.integer :newie_id
			t.string :title
			t.attachment :picture
		end
	end
end