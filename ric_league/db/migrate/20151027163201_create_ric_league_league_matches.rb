class CreateRicLeagueLeagueMatches < ActiveRecord::Migration
	def change
		create_table :league_matches do |t|

			# Timestamps
			t.timestamps null: true

			# Relation to season
			t.integer :league_season_id
			
			# Identification
			t.datetime :played_at
			t.integer :team1_id
			t.integer :team2_id
			
			# Result
			t.integer :result1
			t.integer :result2
			t.integer :points1
			t.integer :points2
			t.boolean :overtime
			
		end
	end
end
