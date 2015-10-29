# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * League seasons
# *
# * Author: Matěj Outlý
# * Date  : 29. 10. 2015
# *
# *****************************************************************************

module RicLeague
	module Concerns
		module Controllers
			module Admin
				module LeagueSeasonsController extend ActiveSupport::Concern

					#
					# 'included do' causes the included code to be evaluated in the
					# context where it is included, rather than being executed in 
					# the module's context.
					#
					included do
					
						#
						# Set team before some actions
						#
						before_action :set_league_season, only: [:show, :edit, :update, :destroy]

					end

					#
					# Index action
					#
					def index
						@league_seasons = RicLeague.league_season_model.all.order(started_at: :desc).page(params[:page]).per(50)
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
						@league_season = RicLeague.league_season_model.new
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
						@league_season = RicLeague.league_season_model.new(league_season_params)
						if @league_season.save
							respond_to do |format|
								format.html { redirect_to league_season_path(@league_season), notice: I18n.t("activerecord.notices.models.#{RicLeague.league_season_model.model_name.i18n_key}.create") }
								format.json { render json: @league_season.id }
							end
						else
							respond_to do |format|
								format.html { render "new" }
								format.json { render json: @league_season.errors }
							end
						end
					end

					#
					# Update action
					#
					def update
						if @league_season.update(league_season_params)
							respond_to do |format|
								format.html { redirect_to league_season_path(@league_season), notice: I18n.t("activerecord.notices.models.#{RicLeague.league_season_model.model_name.i18n_key}.update") }
								format.json { render json: @league_season.id }
							end
						else
							respond_to do |format|
								format.html { render "edit" }
								format.json { render json: @league_season.errors }
							end
						end
					end

					#
					# Destroy action
					#
					def destroy
						@league_season.destroy
						respond_to do |format|
							format.html { redirect_to league_seasons_path, notice: I18n.t("activerecord.notices.models.#{RicLeague.league_season_model.model_name.i18n_key}.destroy") }
							format.json { render json: @league_season.id }
						end
					end

				protected

					#
					# Set model
					#
					def set_league_season
						@league_season = RicLeague.league_season_model.find_by_id(params[:id])
						if @league_season.nil?
							redirect_to league_seasons_path, alert: I18n.t("activerecord.errors.models.#{RicLeague.league_season_model.model_name.i18n_key}.not_found")
						end
					end

					# 
					# Never trust parameters from the scary internet, only allow the white list through.
					#
					def league_season_params
						params.require(:league_season).permit(:name, :started_at, :finished_at)
					end

				end
			end
		end
	end
end
