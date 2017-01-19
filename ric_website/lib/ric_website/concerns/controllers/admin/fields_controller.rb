# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Fields
# *
# * Author: Matěj Outlý
# * Date  : 19. 1. 2017
# *
# *****************************************************************************

module RicWebsite
	module Concerns
		module Controllers
			module Admin
				module FieldsController extend ActiveSupport::Concern

					#
					# 'included do' causes the included code to be evaluated in the
					# context where it is included, rather than being executed in 
					# the module's context.
					#
					included do
						
						before_action :save_referrer, only: [:new, :edit]
						before_action :set_structure
						before_action :set_field, only: [:show, :edit, :update, :move, :destroy]

					end

					def show
						respond_to do |format|
							format.html { render "show" }
							format.json { render json: @field.to_json }
						end
					end

					def new
						@field = RicWebsite.field_model.new(structure_id: @structure.id)
					end

					def edit
					end

					def create
						@field = RicWebsite.field_model.new(field_params)
						@field.structure_id = @structure.id
						if @field.save
							respond_to do |format|
								format.html { redirect_to load_referrer, notice: I18n.t("activerecord.notices.models.#{RicWebsite.field_model.model_name.i18n_key}.create") }
								format.json { render json: @field.id }
							end
						else
							respond_to do |format|
								format.html { render "new" }
								format.json { render json: @field.errors }
							end
						end
					end

					def update
						if @field.update(field_params)
							respond_to do |format|
								format.html { redirect_to load_referrer, notice: I18n.t("activerecord.notices.models.#{RicWebsite.field_model.model_name.i18n_key}.update") }
								format.json { render json: @field.id }
							end
						else
							respond_to do |format|
								format.html { render "edit" }
								format.json { render json: @field.errors }
							end
						end
					end

					def move
						if RicWebsite.field_model.move(params[:id], params[:relation], params[:destination_id])
							respond_to do |format|
								format.html { redirect_to request.referrer, notice: I18n.t("activerecord.notices.models.#{RicWebsite.field_model.model_name.i18n_key}.move") }
								format.json { render json: true }
							end
						else
							respond_to do |format|
								format.html { redirect_to equest.referrer, alert: I18n.t("activerecord.errors.models.#{RicWebsite.field_model.model_name.i18n_key}.move") }
								format.json { render json: false }
							end
						end
					end

					def destroy
						@field.destroy
						respond_to do |format|
							format.html { redirect_to request.referrer, notice: I18n.t("activerecord.notices.models.#{RicWebsite.field_model.model_name.i18n_key}.destroy") }
							format.json { render json: @field.id }
						end
					end

				protected

					# *************************************************************************
					# Model setters
					# *************************************************************************

					def set_field
						@field = RicWebsite.field_model.find_by_id(params[:id])
						if @field.nil? || @field.structure_id != @structure.id
							redirect_to structures_path, alert: I18n.t("activerecord.errors.models.#{RicWebsite.field_model.model_name.i18n_key}.not_found")
						end
					end

					def set_structure
						@structure = RicWebsite.structure_model.find_by_id(params[:structure_id])
						if @structure.nil?
							redirect_to structures_path, alert: I18n.t("activerecord.errors.models.#{RicWebsite.structure_model.model_name.i18n_key}.not_found")
						end
					end

					# *************************************************************************
					# Param filters
					# *************************************************************************

					def field_params
						params.require(:field).permit(RicWebsite.field_model.permitted_columns)
					end

				end
			end
		end
	end
end
