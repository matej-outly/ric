# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Teams
# *
# * Author: Matěj Outlý
# * Date  : 20. 11. 2015
# *
# *****************************************************************************

module RicLeague
	module Concerns
		module Controllers
			module Public
				module ActiveTeamsController extend ActiveSupport::Concern

					#
					# 'included do' causes the included code to be evaluated in the
					# context where it is included, rather than being executed in 
					# the module's context.
					#
					included do
						
						#
						# Set team before some actions
						#
						before_action :set_league_seasons, only: [:index]

						#
						# Set team before some actions
						#
						before_action :set_team, only: [:show]

						#
						# Set team before some actions
						#
						before_action :set_league_season, only: [:show]

					end

					#
					# Index action
					#
					def index
					end

					#
					# Show action
					#
					def show
					end

				protected

					def set_league_seasons
						@league_seasons = RicLeague.league_season_model.where(active: true).order(started_at: :desc)
					end

					def set_team
						@team = RicLeague.team_model.find_by_id(params[:id])
						if @team.nil?
							redirect_to ric_league_public.active_teams_path, alert: I18n.t("activerecord.errors.models.#{RicLeague.team_model.model_name.i18n_key}.not_found")
						end
					end

					def set_league_season
						@league_season = @team.league_seasons.where(active: true).order(started_at: :desc).first
						if @league_season.nil?
							redirect_to ric_league_public.active_teams_path, alert: I18n.t("activerecord.errors.models.#{RicLeague.team_model.model_name.i18n_key}.not_found")
						end
					end

				end
			end
		end
	end
end
