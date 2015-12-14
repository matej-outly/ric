# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Resources
# *
# * Author: Matěj Outlý
# * Date  : 7. 12. 2015
# *
# *****************************************************************************

module RicReservation
	module Concerns
		module Controllers
			module Admin
				module ResourcesController extend ActiveSupport::Concern

					#
					# 'included do' causes the included code to be evaluated in the
					# context where it is included, rather than being executed in 
					# the module's context.
					#
					included do
						
						before_action :set_type
						before_action :set_resource, only: [:show, :edit, :update]

					end

					#
					# Index action
					#
					def index
						@resources = type_model.all.order(position: :asc)
					end

					#
					# Show action
					#
					def show
						today = Date.today
						@valid_once_events = @resource.events.valid(today).where(period: "once").order(from: :asc)
						@valid_other_events = @resource.events.valid(today).where("period <> ?", "once").order(from: :asc)
						@yet_invalid_events = @resource.events.yet_invalid(today).order(from: :asc)
						@already_invalid_events = @resource.events.already_invalid(today).order(from: :asc)
					end

					#
					# New action
					#
					def new
						@resource = type_model.new
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
						@resource = type_model.new(resource_params)
						if @resource.save
							redirect_to ric_reservation_admin.resource_path(@resource), notice: I18n.t("activerecord.notices.models.#{type_model.model_name.i18n_key}.create")
						else
							render "new"
						end
					end

					#
					# Update action
					#
					def update
						if @resource.update(resource_params)
							redirect_to ric_reservation_admin.resource_path(@resource), notice: I18n.t("activerecord.notices.models.#{type_model.model_name.i18n_key}.update")
						else
							render "edit"
						end
					end

					#
					# Move action
					#
					def move
						if type_model.move(params[:id], params[:relation], params[:destination_id])
							respond_to do |format|
								format.html { redirect_to ric_reservation_admin.resources_path, notice: I18n.t("activerecord.notices.models.#{type_model.model_name.i18n_key}.move") }
								format.json { render json: true }
							end
						else
							respond_to do |format|
								format.html { redirect_to root_path, alert: I18n.t("activerecord.errors.models.#{type_model.model_name.i18n_key}.move") }
								format.json { render json: false }
							end
						end
					end

				private

					# *********************************************************
					# STI
					# *********************************************************

					def set_type 
						@type = RicReservation.resource_model.types.include?(params[:type]) ? params[:type] : RicReservation.resource_model.to_s 
					end
					
					def type_model
						@type.constantize 
					end

					# *********************************************************
					# Model
					# *********************************************************

					def set_resource
						@resource = type_model.find_by_id(params[:id])
						if @resource.nil?
							redirect_to root_path, alert: I18n.t("activerecord.errors.models.#{type_model.model_name.i18n_key}.not_found")
						end
					end

					# *********************************************************
					# Params
					# *********************************************************

					# 
					# Never trust parameters from the scary internet, only allow the white list through.
					#
					def resource_params
						params.require(:resource).permit(:name, :time_window_soon, :time_window_deadline)
					end

				end
			end
		end
	end
end