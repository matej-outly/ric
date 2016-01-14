# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Event reservations
# *
# * Author: Matěj Outlý
# * Date  : 7. 12. 2015
# *
# *****************************************************************************

module RicReservation
	module Concerns
		module Controllers
			module Admin
				module EventReservationsController extend ActiveSupport::Concern

					#
					# 'included do' causes the included code to be evaluated in the
					# context where it is included, rather than being executed in 
					# the module's context.
					#
					included do

						before_action :set_owner, only: [:create, :create_anonymous]
						before_action :set_event, only: [:index, :new, :create, :create_anonymous]
						before_action :set_reservation, only: [:destroy]

					end

					#
					# Index action
					#
					def index
						@reservations_above_line = RicReservation.reservation_model.where(event_id: @event.id, schedule_date: @event.schedule_date).above_line.order(created_at: :asc)
						@reservations_below_line = RicReservation.reservation_model.where(event_id: @event.id, schedule_date: @event.schedule_date).below_line.order(created_at: :asc)
					end

					#
					# New action
					#
					def new
						@reservation = RicReservation.reservation_model.new
					end

					#
					# Create action
					#
					def create
						reservation = @event.create_reservation(@owner, 1, true)
						if !reservation.nil?
							redirect_to ric_reservation_admin.event_reservations_path(id: @event.id, schedule_date: @event.schedule_date), notice: I18n.t("activerecord.notices.models.ric_reservation/reservation.create")
						else
							redirect_to root_path, alert: I18n.t("activerecord.errors.models.#{RicReservation.reservation_model.model_name.i18n_key}.create_at_capacity_or_closed")
						end
					end

					#
					# Create anonymous action
					#
					def create_anonymous
						reservation = @event.create_reservation(@owner, 1, true)
						if !reservation.nil?
							reservation.save
							redirect_to ric_reservation_admin.event_reservations_path(id: @event.id, schedule_date: @event.schedule_date), notice: I18n.t("activerecord.notices.models.ric_reservation/reservation.create")
						else
							redirect_to root_path, alert: I18n.t("activerecord.errors.models.#{RicReservation.reservation_model.model_name.i18n_key}.create_at_capacity_or_closed")
						end
					end

					#
					# Destroy action
					#
					def destroy
						@reservation.destroy
						redirect_to ric_reservation_admin.event_reservations_path(id: @reservation.event_id, schedule_date: @reservation.schedule_date), notice: I18n.t("activerecord.notices.models.ric_reservation/reservation.destroy")
					end

				private

					def set_owner
						@owner = nil
						if !reservation_params["owner_id"].blank?
							@owner = Teacher.find_by_id(reservation_params["owner_id"])
						end
						if @owner.nil? && !reservation_params["owner_name"].blank?
							@owner = OpenStruct.new(name: reservation_params["owner_name"])
						end
						if @owner.nil?
							@owner = OpenStruct.new(name: I18n.t("activerecord.attributes.#{RicReservation.reservation_model.model_name.i18n_key}.owner_name_anonymous"))
						end
					end

					def set_event
						if params[:schedule_date].nil?
							redirect_to root_path, alert: I18n.t("activerecord.errors.models.#{RicReservation.event_model.model_name.i18n_key}.not_found")
						end
						schedule_date = Date.parse(params[:schedule_date])
						@event = RicReservation.event_model.find_by_id(params[:id])
						if @event.nil?
							redirect_to root_path, alert: I18n.t("activerecord.errors.models.#{RicReservation.event_model.model_name.i18n_key}.not_found")
						end
						@event.schedule(schedule_date)
					end

					def set_reservation
						@reservation = RicReservation.reservation_model.where(id: params[:id], kind: "event").first
						if @reservation.nil?
							redirect_to root_path, alert: I18n.t("activerecord.errors.models.#{RicReservation.reservation_model.model_name.i18n_key}.not_found")
						end
					end

					# 
					# Never trust parameters from the scary internet, only allow the white list through.
					#
					def reservation_params
						if params[:reservation]
							return params[:reservation].permit(:owner_name, :owner_id)
						else
							return {}
						end
					end

				end
			end
		end
	end
end