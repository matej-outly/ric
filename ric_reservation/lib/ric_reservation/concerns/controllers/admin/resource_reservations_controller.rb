# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Resource reservations
# *
# * Author: Matěj Outlý
# * Date  : 7. 12. 2015
# *
# *****************************************************************************

module RicReservation
	module Concerns
		module Controllers
			module Admin
				module ResourceReservationsController extend ActiveSupport::Concern

					#
					# 'included do' causes the included code to be evaluated in the
					# context where it is included, rather than being executed in 
					# the module's context.
					#
					included do
						
						before_action :set_reservation, only: [:show, :edit, :update, :destroy]

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
						if !params[:resource_id]
							redirect_to root_path, alert: I18n.t("activerecord.errors.models.#{RicReservation.reservation_model.model_name.i18n_key}.attributes.resource_id.blank")
							return
						end
						@reservation = RicReservation.reservation_model.new(resource_id: params[:resource_id])
						@reservation.owner_id = current_user.id
						if params[:schedule_date]
							@reservation.schedule_date = Date.parse(params[:schedule_date])
						end
						if params[:time_from]
							@reservation.time_from = DateTime.parse(params[:time_from])
							@reservation.time_to = @reservation.time_from + 1.hour
						end
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
						@reservation = RicReservation.reservation_model.new(reservation_params)
						@reservation.kind = "resource"
						if @reservation.save
							respond_to do |format|
								format.html { redirect_to ric_reservation_admin.resource_reservation_path(@reservation), notice: I18n.t("activerecord.notices.models.#{RicReservation.reservation_model.model_name.i18n_key}.create") }
								format.json { render json: @reservation.id }
							end
						else
							respond_to do |format|
								format.html { render "new" }
								format.json { render json: @reservation.errors }
							end
						end
					end

					#
					# Update action
					#
					def update
						if @reservation.update(reservation_params)
							respond_to do |format|
								format.html { redirect_to ric_reservation_admin.resource_reservation_path(@reservation), notice: I18n.t("activerecord.notices.models.#{RicReservation.reservation_model.model_name.i18n_key}.update") }
								format.json { render json: @reservation.id }
							end
						else
							respond_to do |format|
								format.html { render "edit" }
								format.json { render json: @reservation.errors }
							end
						end
					end

					#
					# Destroy action
					#
					def destroy
						@reservation.destroy
						respond_to do |format|
							format.html { redirect_to ric_reservation_admin.resource_path(@reservation.resource_id), notice: I18n.t("activerecord.notices.models.#{RicReservation.reservation_model.model_name.i18n_key}.destroy") }
							format.json { render json: @reservation.id }
						end
					end

				private
					
					# *********************************************************
					# Model
					# *********************************************************

					def set_reservation
						@reservation = RicReservation.reservation_model.where(id: params[:id], kind: "resource").first
						if @reservation.nil?
							redirect_to root_path, alert: I18n.t("activerecord.errors.models.#{RicReservation.reservation_model.model_name.i18n_key}.not_found")
						end
					end

					# *********************************************************
					# Params
					# *********************************************************

					# 
					# Never trust parameters from the scary internet, only allow the white list through.
					#
					def reservation_params
						params.require(:reservation).permit(:resource_id, :owner_id, :name, :schedule_date, :time_from, :time_to, :color)
					end

				end
			end
		end
	end
end
