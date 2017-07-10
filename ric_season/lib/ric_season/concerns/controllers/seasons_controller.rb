# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Seasons
# *
# * Author: Matěj Outlý
# * Date  : 22. 4. 2016
# *
# *****************************************************************************

module RicSeason
	module Concerns
		module Controllers
			module SeasonsController extend ActiveSupport::Concern

				included do
				
					before_action :set_season, only: [:show, :edit, :update, :make_current, :destroy]

				end

				def index
					@seasons = RicSeason.season_model.all.order(from: :desc)
				end

				def search
					@seasons = RicSeason.season_model.search(params[:q]).order(from: :desc)
					respond_to do |format|
						format.html { render "index" }
						format.json { render json: @seasons.to_json }
					end
				end

				def show
					respond_to do |format|
						format.html { render "show" }
						format.json { render json: @season.to_json }
					end
				end

				def new
					@season = RicSeason.season_model.new
				end

				def edit
				end

				def create
					@season = RicSeason.season_model.new(season_params)
					if @season.save
						respond_to do |format|
							format.html { redirect_to ric_season_admin.season_path(@season), notice: I18n.t("activerecord.notices.models.#{RicSeason.season_model.model_name.i18n_key}.create") }
							format.json { render json: @season.id }
						end
					else
						respond_to do |format|
							format.html { render "new" }
							format.json { render json: @season.errors }
						end
					end
				end

				def update
					if @season.update(season_params)
						respond_to do |format|
							format.html { redirect_to ric_season_admin.season_path(@season), notice: I18n.t("activerecord.notices.models.#{RicSeason.season_model.model_name.i18n_key}.update") }
							format.json { render json: @season.id }
						end
					else
						respond_to do |format|
							format.html { render "edit" }
							format.json { render json: @season.errors }
						end
					end
				end

				def make_current
					@season.current = true
					@season.save
					respond_to do |format|
						format.html { redirect_to ric_season_admin.seasons_path, notice: I18n.t("activerecord.notices.models.#{RicSeason.season_model.model_name.i18n_key}.make_current") }
						format.json { render json: @season.id }
					end
				end

				def destroy
					@season.destroy
					respond_to do |format|
						format.html { redirect_to ric_season_admin.seasons_path, notice: I18n.t("activerecord.notices.models.#{RicSeason.season_model.model_name.i18n_key}.destroy") }
						format.json { render json: @season.id }
					end
				end

			protected

				def set_season
					@season = RicSeason.season_model.find_by_id(params[:id])
					if @season.nil?
						redirect_to ric_season_admin.seasons_path, alert: I18n.t("activerecord.errors.models.#{RicSeason.season_model.model_name.i18n_key}.not_found")
					end
				end

				def season_params
					params.require(:season).permit(RicSeason.season_model.permitted_columns)
				end

			end
		end
	end
end
