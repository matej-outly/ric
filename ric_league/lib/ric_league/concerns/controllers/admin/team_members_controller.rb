# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Team members
# *
# * Author: Matěj Outlý
# * Date  : 29. 10. 2015
# *
# *****************************************************************************

module RicLeague
	module Concerns
		module Controllers
			module Admin
				module TeamMembersController extend ActiveSupport::Concern

					#
					# 'included do' causes the included code to be evaluated in the
					# context where it is included, rather than being executed in 
					# the module's context.
					#
					included do
					
						#
						# Set team member before some actions
						#
						before_action :set_team_member, only: [:show, :edit, :update, :move, :destroy]

					end

					#
					# Show action
					#
					def show
						respond_to do |format|
							format.html { render "show" }
							format.json { render json: @team_member.to_json(methods: :photo_url) }
						end
					end

					#
					# New action
					#
					def new
						@team_member = RicLeague.team_member_model.new
						@team_member.team_id = params[:team_id] if params[:team_id]
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
						@team_member = RicLeague.team_member_model.new(team_member_params)
						if @team_member.save
							respond_to do |format|
								format.html { redirect_to team_member_path(@team_member), notice: I18n.t("activerecord.notices.models.#{RicLeague.team_member_model.model_name.i18n_key}.create") }
								format.json { render json: @team_member.id }
							end
						else
							respond_to do |format|
								format.html { render "new" }
								format.json { render json: @team_member.errors }
							end
						end
					end

					#
					# Update action
					#
					def update
						if @team_member.update(team_member_params)
							respond_to do |format|
								format.html { redirect_to team_member_path(@team_member), notice: I18n.t("activerecord.notices.models.#{RicLeague.team_member_model.model_name.i18n_key}.update") }
								format.json { render json: @team_member.id }
							end
						else
							respond_to do |format|
								format.html { render "edit" }
								format.json { render json: @team_member.errors }
							end
						end
					end

					#
					# Move action
					#
					def move
						if RicLeague.team_member_model.move(params[:id], params[:relation], params[:destination_id])
							respond_to do |format|
								format.html { redirect_to team_path(@team_member.team_id), notice: I18n.t("activerecord.notices.models.#{RicLeague.team_member_model.model_name.i18n_key}.move") }
								format.json { render json: true }
							end
						else
							respond_to do |format|
								format.html { redirect_to team_path(@team_member.team_id), alert: I18n.t("activerecord.errors.models.#{RicLeague.team_member_model.model_name.i18n_key}.move") }
								format.json { render json: false }
							end
						end
					end

					#
					# Destroy action
					#
					def destroy
						@team_member.destroy
						respond_to do |format|
							format.html { redirect_to team_path(@team_member.team_id), notice: I18n.t("activerecord.notices.models.#{RicLeague.team_member_model.model_name.i18n_key}.destroy") }
							format.json { render json: @team_member.id }
						end
					end

				protected

					def set_team_member
						@team_member = RicLeague.team_member_model.find_by_id(params[:id])
						if @team_member.nil?
							redirect_to team_members_path, alert: I18n.t("activerecord.errors.models.#{RicLeague.team_member_model.model_name.i18n_key}.not_found")
						end
					end

					# 
					# Never trust parameters from the scary internet, only allow the white list through.
					#
					def team_member_params
						params.require(:team_member).permit(:team_id, :league_category_id, :name, :kind, :role, :classification, :dress_number, :photo, :photo_crop_x, :photo_crop_y, :photo_crop_w, :photo_crop_h, :description)
					end

				end
			end
		end
	end
end
