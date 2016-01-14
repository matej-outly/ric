# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * League categories
# *
# * Author: Matěj Outlý
# * Date  : 14. 1. 2016
# *
# *****************************************************************************

module RicLeague
	module Concerns
		module Controllers
			module Admin
				module LeagueCategoriesController extend ActiveSupport::Concern

					#
					# 'included do' causes the included code to be evaluated in the
					# context where it is included, rather than being executed in 
					# the module's context.
					#
					included do
					
						#
						# Set team before some actions
						#
						before_action :set_league_category, only: [:show, :edit, :update, :destroy]

					end

					#
					# Index action
					#
					def index
						@league_categories = RicLeague.league_category_model.all.order(position: :asc)
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
						@league_category = RicLeague.league_category_model.new
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
						@league_category = RicLeague.league_category_model.new(league_category_params)
						if @league_category.save
							respond_to do |format|
								format.html { redirect_to league_category_path(@league_category), notice: I18n.t("activerecord.notices.models.#{RicLeague.league_category_model.model_name.i18n_key}.create") }
								format.json { render json: @league_category.id }
							end
						else
							respond_to do |format|
								format.html { render "new" }
								format.json { render json: @league_category.errors }
							end
						end
					end

					#
					# Update action
					#
					def update
						if @league_category.update(league_category_params)
							respond_to do |format|
								format.html { redirect_to league_category_path(@league_category), notice: I18n.t("activerecord.notices.models.#{RicLeague.league_category_model.model_name.i18n_key}.update") }
								format.json { render json: @league_category.id }
							end
						else
							respond_to do |format|
								format.html { render "edit" }
								format.json { render json: @league_category.errors }
							end
						end
					end

					#
					# Move action
					#
					def move
						if RicLeague.league_category_model.move(params[:id], params[:relation], params[:destination_id])
							respond_to do |format|
								format.html { redirect_to league_categories_path, notice: I18n.t("activerecord.notices.models.#{RicLeague.league_category_model.model_name.i18n_key}.move") }
								format.json { render json: true }
							end
						else
							respond_to do |format|
								format.html { redirect_to league_categories_path, alert: I18n.t("activerecord.errors.models.#{RicLeague.league_category_model.model_name.i18n_key}.move") }
								format.json { render json: false }
							end
						end
					end

					#
					# Destroy action
					#
					def destroy
						@league_category.destroy
						respond_to do |format|
							format.html { redirect_to league_categories_path, notice: I18n.t("activerecord.notices.models.#{RicLeague.league_category_model.model_name.i18n_key}.destroy") }
							format.json { render json: @league_category.id }
						end
					end

				protected

					#
					# Set model
					#
					def set_league_category
						@league_category = RicLeague.league_category_model.find_by_id(params[:id])
						if @league_category.nil?
							redirect_to league_categories_path, alert: I18n.t("activerecord.errors.models.#{RicLeague.league_category_model.model_name.i18n_key}.not_found")
						end
					end

					# 
					# Never trust parameters from the scary internet, only allow the white list through.
					#
					def league_category_params
						params.require(:league_category).permit(:name)
					end

				end
			end
		end
	end
end