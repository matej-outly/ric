class CreateRicLeagueTeams < ActiveRecord::Migration
	def change
		create_table :teams do |t|

			# Timestamps
			t.timestamps null: true
			
			# Position
			t.integer :position
			
			# Identification
			t.string :key
			t.string :name
			t.boolean :home
			t.integer :league_category_id

			# Description
			t.text :description
			t.attachment :logo
			t.attachment :photo
			t.integer :photo_crop_x
			t.integer :photo_crop_y
			t.integer :photo_crop_w
			t.integer :photo_crop_h

		end
	end
end
