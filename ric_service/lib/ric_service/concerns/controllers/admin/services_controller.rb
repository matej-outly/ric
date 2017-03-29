# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Services
# *
# * Author: Matěj Outlý
# * Date  : 29. 3. 2017
# *
# *****************************************************************************

module RicService
	module Concerns
		module Controllers
			module Admin
				module ServicesController extend ActiveSupport::Concern

					#
					# 'included do' causes the included code to be evaluated in the
					# context where it is included, rather than being executed in 
					# the module's context.
					#
					included do
					
						before_action :set_service, only: [:show, :edit, :update, :move, :destroy]

					end

					def index
						@services = RicService.service_model.all.order(position: :asc).page(params[:page]).per(50)
					end

					def show
						respond_to do |format|
							format.html { render "show" }
							format.json { render json: @service.to_json }
						end
					end

					def new
						@service = RicService.service_model.new
					end

					def edit
					end

					def create
						@service = RicService.service_model.new(service_params)
						if @service.save
							respond_to do |format|
								format.html { redirect_to ric_service_admin.service_path(@service), notice: I18n.t("activerecord.notices.models.#{RicService.service_model.model_name.i18n_key}.create") }
								format.json { render json: @service.id }
							end
						else
							respond_to do |format|
								format.html { render "new" }
								format.json { render json: @service.errors }
							end
						end
					end

					def update
						if @service.update(service_params)
							respond_to do |format|
								format.html { redirect_to ric_service_admin.service_path(@service), notice: I18n.t("activerecord.notices.models.#{RicService.service_model.model_name.i18n_key}.update") }
								format.json { render json: @service.id }
							end
						else
							respond_to do |format|
								format.html { render "edit" }
								format.json { render json: @service.errors }
							end
						end
					end

					def move
						if RicService.service_model.move(params[:id], params[:relation], params[:destination_id])
							respond_to do |format|
								format.html { redirect_to ric_service_admin.services_path, notice: I18n.t("activerecord.notices.models.#{RicService.service_model.model_name.i18n_key}.move") }
								format.json { render json: true }
							end
						else
							respond_to do |format|
								format.html { redirect_to ric_service_admin.services_path, alert: I18n.t("activerecord.errors.models.#{RicService.service_model.model_name.i18n_key}.move") }
								format.json { render json: false }
							end
						end
					end
					
					def destroy
						@service.destroy
						respond_to do |format|
							format.html { redirect_to ric_service_admin.services_path, notice: I18n.t("activerecord.notices.models.#{RicService.service_model.model_name.i18n_key}.destroy") }
							format.json { render json: @service.id }
						end
					end

				protected

					def set_service
						@service = RicService.service_model.find_by_id(params[:id])
						if @service.nil?
							redirect_to ric_service_admin.services_path, alert: I18n.t("activerecord.errors.models.#{RicService.service_model.model_name.i18n_key}.not_found")
						end
					end

					def service_params
						params.require(:service).permit(RicService.service_model.permitted_columns)
					end

				end
			end
		end
	end
end
