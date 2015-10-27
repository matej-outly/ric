class CreateRicLeagueTeamMembers < ActiveRecord::Migration
	def change
		create_table :team_members do |t|

			# Timestamps
			t.timestamps null: true

			# Position
			t.integer :position
			
			# Relation to team
			t.integer :team_id
			
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
			
		end
	end
end
