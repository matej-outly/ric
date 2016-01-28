# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Teams
# *
# * Author: Matěj Outlý
# * Date  : 8. 3. 2015
# *
# *****************************************************************************

module RicLeague
	module Concerns
		module Controllers
			module Admin
				module TeamsController extend ActiveSupport::Concern

					#
					# 'included do' causes the included code to be evaluated in the
					# context where it is included, rather than being executed in 
					# the module's context.
					#
					included do
					
						#
						# Set team before some actions
						#
						before_action :set_team, only: [:show, :edit, :update, :destroy]

					end

					#
					# Index action
					#
					def index
						@teams = RicLeague.team_model.all.order(position: :asc).page(params[:page]).per(50)
					end

					#
					# Show action
					#
					def show
						respond_to do |format|
							format.html { render "show" }
							format.json { render json: @team.to_json(methods: :photo_url) }
						end
					end

					#
					# New action
					#
					def new
						@team = RicLeague.team_model.new
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
						@team = RicLeague.team_model.new(team_params)
						if @team.save
							respond_to do |format|
								format.html { redirect_to team_path(@team), notice: I18n.t("activerecord.notices.models.#{RicLeague.team_model.model_name.i18n_key}.create") }
								format.json { render json: @team.id }
							end
						else
							respond_to do |format|
								format.html { render "new" }
								format.json { render json: @team.errors }
							end
						end
					end

					#
					# Update action
					#
					def update
						if @team.update(team_params)
							respond_to do |format|
								format.html { redirect_to team_path(@team), notice: I18n.t("activerecord.notices.models.#{RicLeague.team_model.model_name.i18n_key}.update") }
								format.json { render json: @team.id }
							end
						else
							respond_to do |format|
								format.html { render "edit" }
								format.json { render json: @team.errors }
							end
						end
					end

					#
					# Move action
					#
					def move
						if RicLeague.team_model.move(params[:id], params[:relation], params[:destination_id])
							respond_to do |format|
								format.html { redirect_to teams_path, notice: I18n.t("activerecord.notices.models.#{RicLeague.team_model.model_name.i18n_key}.move") }
								format.json { render json: true }
							end
						else
							respond_to do |format|
								format.html { redirect_to teams_path, alert: I18n.t("activerecord.errors.models.#{RicLeague.team_model.model_name.i18n_key}.move") }
								format.json { render json: false }
							end
						end
					end

					#
					# Destroy action
					#
					def destroy
						@team.destroy
						respond_to do |format|
							format.html { redirect_to teams_path, notice: I18n.t("activerecord.notices.models.#{RicLeague.team_model.model_name.i18n_key}.destroy") }
							format.json { render json: @team.id }
						end
					end

				protected

					def set_team
						@team = RicLeague.team_model.find_by_id(params[:id])
						if @team.nil?
							redirect_to teams_path, alert: I18n.t("activerecord.errors.models.#{RicLeague.team_model.model_name.i18n_key}.not_found")
						end
					end

					# 
					# Never trust parameters from the scary internet, only allow the white list through.
					#
					def team_params
						params.require(:team).permit(:name, :key, :league_category_id, :description, :home, :logo, :photo, :photo_crop_x, :photo_crop_y, :photo_crop_w, :photo_crop_h)
					end

				end
			end
		end
	end
end
