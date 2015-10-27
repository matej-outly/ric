class CreateRicLeagueLeagueSeasons < ActiveRecord::Migration
	def change
		create_table :league_seasons do |t|

			# Timestamps
			t.timestamps null: true

			# Identification
			t.string :name
			t.date :started_at
			t.date :finished_at

		end
		create_table :league_seasons_teams, id: false do |t|

			# Timestamps
			t.timestamps null: true

			# Relations
			t.integer :team_id
			t.integer :league_season_id

		end
	end
end
