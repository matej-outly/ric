# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Enums
# *
# * Author: Matěj Outlý
# * Date  : 19. 1. 2017
# *
# *****************************************************************************

module RicWebsite
	module Concerns
		module Controllers
			module Admin
				module EnumsController extend ActiveSupport::Concern

					#
					# 'included do' causes the included code to be evaluated in the
					# context where it is included, rather than being executed in 
					# the module's context.
					#
					included do
						
						before_action :save_referrer, only: [:new, :edit]
						before_action :set_enum, only: [:show, :edit, :update, :destroy]

					end

					def index
						@enums = RicWebsite.enum_model.order(ref: :asc)
						respond_to do |format|
							format.html { render "index" }
							format.json { render json: @enums.to_json }
						end
					end

					def search
						@enums = RicWebsite.enum_model.search(params[:q]).order(id: :asc)
						respond_to do |format|
							format.html { render "index" }
							format.json { render json: @enums.to_json }
						end
					end

					def show
						respond_to do |format|
							format.html { render "show" }
							format.json { render json: @enum.to_json }
						end
					end

					def new
						@enum = RicWebsite.enum_model.new
					end

					def edit
					end

					def create
						@enum = RicWebsite.enum_model.new(enum_params)
						if @enum.save
							respond_to do |format|
								format.html { redirect_to load_referrer, notice: I18n.t("activerecord.notices.models.#{RicWebsite.enum_model.model_name.i18n_key}.create") }
								format.json { render json: @enum.id }
							end
						else
							respond_to do |format|
								format.html { render "new" }
								format.json { render json: @enum.errors }
							end
						end
					end

					def update
						if @enum.update(enum_params)
							respond_to do |format|
								format.html { redirect_to load_referrer, notice: I18n.t("activerecord.notices.models.#{RicWebsite.enum_model.model_name.i18n_key}.update") }
								format.json { render json: @enum.id }
							end
						else
							respond_to do |format|
								format.html { render "edit" }
								format.json { render json: @enum.errors }
							end
						end
					end

					def destroy
						@enum.destroy
						respond_to do |format|
							format.html { redirect_to request.referrer, notice: I18n.t("activerecord.notices.models.#{RicWebsite.enum_model.model_name.i18n_key}.destroy") }
							format.json { render json: @enum.id }
						end
					end

				protected

					# *************************************************************************
					# Model setters
					# *************************************************************************

					def set_enum
						@enum = RicWebsite.enum_model.find_by_id(params[:id])
						if @enum.nil?
							redirect_to enums_path, alert: I18n.t("activerecord.errors.models.#{RicWebsite.enum_model.model_name.i18n_key}.not_found")
						end
					end

					# *************************************************************************
					# Param filters
					# *************************************************************************

					def enum_params
						result = params.require(:enum).permit(RicWebsite.enum_model.permitted_columns)
						result[:values] = JSON.parse(result[:values]) if !result[:values].blank?
						return result
					end


				end
			end
		end
	end
end
