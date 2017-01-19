# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Structures
# *
# * Author: Matěj Outlý
# * Date  : 19. 1. 2017
# *
# *****************************************************************************

module RicWebsite
	module Concerns
		module Controllers
			module Admin
				module StructuresController extend ActiveSupport::Concern

					#
					# 'included do' causes the included code to be evaluated in the
					# context where it is included, rather than being executed in 
					# the module's context.
					#
					included do
						
						before_action :save_referrer, only: [:new, :edit]
						before_action :set_structure, only: [:show, :edit, :update, :destroy]

					end

					def index
						@structures = RicWebsite.structure_model.order(ref: :asc).page(params[:page]).per(50)
						respond_to do |format|
							format.html { render "index" }
							format.json { render json: @structures.to_json }
						end
					end

					def show
						respond_to do |format|
							format.html { render "show" }
							format.json { render json: @structure.to_json }
						end
					end

					def new
						@structure = RicWebsite.structure_model.new
					end

					def edit
					end

					def create
						@structure = RicWebsite.structure_model.new(structure_params)
						if @structure.save
							respond_to do |format|
								format.html { redirect_to load_referrer, notice: I18n.t("activerecord.notices.models.#{RicWebsite.structure_model.model_name.i18n_key}.create") }
								format.json { render json: @structure.id }
							end
						else
							respond_to do |format|
								format.html { render "new" }
								format.json { render json: @structure.errors }
							end
						end
					end

					def update
						if @structure.update(structure_params)
							respond_to do |format|
								format.html { redirect_to load_referrer, notice: I18n.t("activerecord.notices.models.#{RicWebsite.structure_model.model_name.i18n_key}.update") }
								format.json { render json: @structure.id }
							end
						else
							respond_to do |format|
								format.html { render "edit" }
								format.json { render json: @structure.errors }
							end
						end
					end

					def destroy
						@structure.destroy
						respond_to do |format|
							format.html { redirect_to request.referrer, notice: I18n.t("activerecord.notices.models.#{RicWebsite.structure_model.model_name.i18n_key}.destroy") }
							format.json { render json: @structure.id }
						end
					end

				protected

					# *************************************************************************
					# Model setters
					# *************************************************************************

					def set_structure
						@structure = RicWebsite.structure_model.find_by_id(params[:id])
						if @structure.nil?
							redirect_to structures_path, alert: I18n.t("activerecord.errors.models.#{RicWebsite.structure_model.model_name.i18n_key}.not_found")
						end
					end

					# *************************************************************************
					# Param filters
					# *************************************************************************

					def structure_params
						params.require(:structure).permit(RicWebsite.structure_model.permitted_columns)
					end

				end
			end
		end
	end
end
