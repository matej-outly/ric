# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * League season team relations
# *
# * Author: Matěj Outlý
# * Date  : 3. 11. 2015
# *
# *****************************************************************************

module RicLeague
	module Concerns
		module Controllers
			module Admin
				module LeagueSeasonTeamRelationsController extend ActiveSupport::Concern

					#
					# 'included do' causes the included code to be evaluated in the
					# context where it is included, rather than being executed in 
					# the module's context.
					#
					included do
					
						#
						# Set league_season before some actions
						#
						before_action :set_league_season, only: [:edit, :update, :destroy]

						#
						# Set team before some actions
						#
						before_action :set_team, only: [:destroy]

					end

					#
					# Edit action
					#
					def edit
						@teams = RicLeague.team_model.all.order(position: :asc)
					end

					#
					# Update action
					#
					def update
						@league_season.team_ids = team_ids_from_params
						redirect_to league_season_path(@league_season), notice: I18n.t("activerecord.notices.models.#{RicLeague.league_season_model.model_name.i18n_key}.bind_team")
					end

					#
					# Destroy action
					#
					def destroy
						@league_season.teams.delete(@team)
						redirect_to league_season_path(@league_season), notice: I18n.t("activerecord.notices.models.#{RicLeague.league_season_model.model_name.i18n_key}.unbind_team")
					end

				protected

					def set_league_season
						@league_season = RicLeague.league_season_model.find_by_id(params[:id])
						if @league_season.nil?
							redirect_to league_seasons_path, alert: I18n.t("activerecord.errors.models.#{RicLeague.league_season_model.model_name.i18n_key}.not_found")
						end
					end

					def set_team
						@team = RicLeague.team_model.find_by_id(params[:team_id])
						if @team.nil?
							redirect_to league_seasons_path, alert: I18n.t("activerecord.errors.models.#{RicLeague.team_model.model_name.i18n_key}.not_found")
						end
					end

					# 
					# Never trust parameters from the scary internet, only allow the white list through.
					#
					def team_ids_from_params
						if params[:league_season] && params[:league_season][:teams] && params[:league_season][:teams].is_a?(Hash)
							return params[:league_season][:teams].keys
						else
							return []
						end
					end

				end
			end
		end
	end
end
