# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * League matches
# *
# * Author: Matěj Outlý
# * Date  : 29. 10. 2015
# *
# *****************************************************************************

module RicLeague
	module Concerns
		module Controllers
			module Admin
				module LeagueMatchesController extend ActiveSupport::Concern

					#
					# 'included do' causes the included code to be evaluated in the
					# context where it is included, rather than being executed in 
					# the module's context.
					#
					included do
					
						#
						# Set team before some actions
						#
						before_action :set_league_match, only: [:show, :edit, :update, :destroy]

					end

					#
					# Index action
					#
					def index
						@league_matches = RicLeague.league_match_model.all.order(played_at: :desc).page(params[:page]).per(50)
					end

					#
					# Show action
					#
					def show
					end

					#
					# New action
					#
					def new
						@league_match = RicLeague.league_match_model.new
						@league_match.league_season_id = params[:league_season_id] if params[:league_season_id]
					end

					#
					# Edit action
					#
					def edit
					end

					#
					# Create action
					#
					def create
						@league_match = RicLeague.league_match_model.new(league_match_params)
						if @league_match.save
							respond_to do |format|
								format.html { redirect_to league_match_path(@league_match), notice: I18n.t("activerecord.notices.models.#{RicLeague.league_match_model.model_name.i18n_key}.create") }
								format.json { render json: @league_match.id }
							end
						else
							respond_to do |format|
								format.html { render "new" }
								format.json { render json: @league_match.errors }
							end
						end
					end

					#
					# Update action
					#
					def update
						if @league_match.update(league_match_params)
							respond_to do |format|
								format.html { redirect_to league_match_path(@league_match), notice: I18n.t("activerecord.notices.models.#{RicLeague.league_match_model.model_name.i18n_key}.update") }
								format.json { render json: @league_match.id }
							end
						else
							respond_to do |format|
								format.html { render "edit" }
								format.json { render json: @league_match.errors }
							end
						end
					end

					#
					# Destroy action
					#
					def destroy
						@league_match.destroy
						respond_to do |format|
							format.html { redirect_to league_matches_path, notice: I18n.t("activerecord.notices.models.#{RicLeague.league_match_model.model_name.i18n_key}.destroy") }
							format.json { render json: @league_match.id }
						end
					end

				protected

					#
					# Set model
					#
					def set_league_match
						@league_match = RicLeague.league_match_model.find_by_id(params[:id])
						if @league_match.nil?
							redirect_to league_matches_path, alert: I18n.t("activerecord.errors.models.#{RicLeague.league_match_model.model_name.i18n_key}.not_found")
						end
					end

					# 
					# Never trust parameters from the scary internet, only allow the white list through.
					#
					def league_match_params
						params.require(:league_match).permit(:league_season_id, :played_at, :overtime, :team1_id, :team2_id, :result1, :result2, :points1, :points2)
					end

				end
			end
		end
	end
end