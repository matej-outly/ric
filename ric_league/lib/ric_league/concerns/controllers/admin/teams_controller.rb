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
							redirect_to team_path(@team), notice: I18n.t("activerecord.notices.models.#{RicLeague.team_model.model_name.i18n_key}.create")
						else
							render "new"
						end
					end

					#
					# Update action
					#
					def update
						if @team.update(team_params)
							redirect_to team_path(@team), notice: I18n.t("activerecord.notices.models.#{RicLeague.team_model.model_name.i18n_key}.update")
						else
							render "edit"
						end
					end

					#
					# Destroy action
					#
					def destroy
						@team.destroy
						redirect_to teams_path, notice: I18n.t("activerecord.notices.models.#{RicLeague.team_model.model_name.i18n_key}.destroy")
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
						params.require(:team).permit(:name, :key, :description, :logo, :photo, :photo_crop_x, :photo_crop_y, :photo_crop_w, :photo_crop_h)
					end

				end
			end
		end
	end
end
