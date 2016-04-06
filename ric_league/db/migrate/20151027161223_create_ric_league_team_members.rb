class CreateRicLeagueTeamMembers < ActiveRecord::Migration
	def change
		create_table :team_members do |t|

			# Timestamps
			t.timestamps null: true

			# Position
			t.integer :position
			
			# Relation to team
			t.integer :team_id
			t.integer :league_category_id
			
			# Identification
			t.string :name
			t.string :kind

			# Stuff classification
			t.string :role
			
			# Player classification 
			t.float :classification
			t.integer :dress_number
			
			# Description
			t.text :description
			t.attachment :photo
			#t.integer :photo_crop_x # Only if croppable
			#t.integer :photo_crop_y # Only if croppable
			#t.integer :photo_crop_w # Only if croppable
			#t.integer :photo_crop_h # Only if croppable
			
		end
	end
end
