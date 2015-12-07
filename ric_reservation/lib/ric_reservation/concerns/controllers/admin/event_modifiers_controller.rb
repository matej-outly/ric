# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Event modifiers
# *
# * Author: Matěj Outlý
# * Date  : 7. 12. 2015
# *
# *****************************************************************************

module RicReservation
	module Concerns
		module Controllers
			module Admin
				module EventModifiersController extend ActiveSupport::Concern

					#
					# 'included do' causes the included code to be evaluated in the
					# context where it is included, rather than being executed in 
					# the module's context.
					#
					included do
						
						before_action :set_event, only: [:new_tmp_trainer, :create]
						before_action :set_event_modifier, only: [:destroy]
						
					end

					def create
						if params[:type] == "tmp_canceled"
							type = :tmp_canceled
							tmp_trainer_id = nil
						else
							redirect_to root_path, alert: I18n.t("activerecord.errors.models.ric_reservation/event_modifier.create_unknown_type")
						end
						event_modifier = @event.create_modifier(type)
						if !event_modifier.nil?
							redirect_to ric_reservation_admin.event_reservations_path(id: @event.id, schedule_date: @event.schedule_date), notice: I18n.t("activerecord.notices.models.ric_reservation/event_modifier.create")
						else
							redirect_to root_path, alert: I18n.t("activerecord.errors.models.ric_reservation/event_modifier.create_unknown")
						end
					end

					def destroy
						@event_modifier.destroy
						redirect_to ric_reservation_admin.event_reservations_path(id: @event_modifier.event_id, schedule_date: @event_modifier.schedule_date), notice: I18n.t("activerecord.notices.models.ric_reservation/event_modifier.destroy")
					end

				private

					def set_event
						if params[:schedule_date].nil?
							redirect_to root_path, alert: I18n.t("activerecord.errors.models.ric_reservation/event.not_found")
						end
						schedule_date = Date.parse(params[:schedule_date])
						@event = RicReservation.event_model.find_by_id(params[:id])
						if @event.nil?
							redirect_to root_path, alert: I18n.t("activerecord.errors.models.ric_reservation/event.not_found")
						end
						@event.schedule(schedule_date)
					end

					def set_event_modifier
						@event_modifier = RicReservation.event_modifier_model.find_by_id(params[:id])
						if @event_modifier.nil?
							redirect_to root_path, alert: I18n.t("activerecord.errors.models.ric_reservation/event_modifier.not_found")
						end
					end
					
				end
			end
		end
	end
end