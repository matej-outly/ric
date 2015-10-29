# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Team
# *
# * Author: Matěj Outlý
# * Date  : 27. 10. 2015
# *
# *****************************************************************************

module RicLeague
	module Concerns
		module Models
			module Team extend ActiveSupport::Concern

				#
				# 'included do' causes the included code to be evaluated in the
				# context where it is included, rather than being executed in 
				# the module's context.
				#
				included do
					
					# *********************************************************************
					# Structure
					# *********************************************************************

					#
					# Relation to team members
					#
					has_many :team_members, class_name: RicLeague.team_member_model.to_s, dependent: :destroy

					#
					# Relation to league seasons
					#
					has_and_belongs_to_many :league_seasons, class_name: RicLeague.league_season_model.to_s

					#
					# Ordering
					#
					enable_ordering

					# *************************************************************************
					# Attachments
					# *************************************************************************

					#
					# Photo
					#
					croppable_picture_column :photo, styles: { thumb: config(:photo_crop, :thumb), full: config(:photo_crop, :full) }

					#
					# Logo
					#
					has_attached_file :logo, :styles => { :full => config(:logo_crop, :full) }
					validates_attachment_content_type :logo, :content_type => /\Aimage\/.*\Z/

				end

				module ClassMethods

					def league_ladder(league_season = nil)
						league_season ||= RicLeague.league_season_model.current
						result = league_season.teams
						result = result.sort { |team1, team2| team1.league_points(league_season) <=> team2.league_points(league_season) }
						return result
					end

				end

				# *************************************************************************
				# Virtual attributes related to members
				# *************************************************************************

				def players
					self.team_members.where(kind: "player")
				end

				def stuff_members
					self.team_members.where(kind: "stuff")
				end

				# *************************************************************************
				# Virtual attributes related to league
				# *************************************************************************

				def matches_count(league_season = nil)
					league_season ||= RicLeague.league_season_model.current
					return league_season.league_matches.already_played.where("team1_id = :id OR team2_id = :id", id: self.id).count
				end

				def wins_count(league_season = nil)
					league_season ||= RicLeague.league_season_model.current
					return league_season.league_matches.already_played.where("(team1_id = :id AND result1 > result2) OR (team2_id = :id AND result2 > result1)", id: self.id).count
				end

				def defeats_count(league_season = nil)
					league_season ||= RicLeague.league_season_model.current
					return league_season.league_matches.already_played.where("(team1_id = :id AND result1 < result2) OR (team2_id = :id AND result2 < result1)", id: self.id).count
				end

				def wins_in_overtime_count(league_season = nil)
					league_season ||= RicLeague.league_season_model.current
					return league_season.league_matches.already_played.where(overtime: true).where("(team1_id = :id AND result1 > result2) OR (team2_id = :id AND result2 > result1)", id: self.id).count
				end

				def defeats_in_overtime_count(league_season = nil)
					league_season ||= RicLeague.league_season_model.current
					return league_season.league_matches.already_played.where(overtime: true).where("(team1_id = :id AND result1 < result2) OR (team2_id = :id AND result2 < result1)", id: self.id).count
				end

				def given_goals_count(league_season = nil)
					league_season ||= RicLeague.league_season_model.current
					return league_season.league_matches.already_played.where(team1_id: self.id).sum(:result1).to_i + league_season.league_matches.where(team2_id: self.id).sum(:result2).to_i
				end

				def taken_goals_count(league_season = nil)
					league_season ||= RicLeague.league_season_model.current
					return league_season.league_matches.already_played.where(team1_id: self.id).sum(:result2).to_i + league_season.league_matches.where(team2_id: self.id).sum(:result1).to_i
				end

				def league_points(league_season = nil)
					league_season ||= RicLeague.league_season_model.current
					return league_season.league_matches.already_played.where(team1_id: self.id).sum(:points1).to_i + league_season.league_matches.where(team2_id: self.id).sum(:points2).to_i
				end

				def league_position(league_season = nil)
					league_season ||= RicLeague.league_season_model.current
					ladder = self.class.league_ladder(league_season)
					idx = ladder.index(self)
					return idx ? (ladder.length - idx) : nil
				end

			end
		end
	end
end