# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Events
# *
# * Author: Matěj Outlý
# * Date  : 7. 12. 2015
# *
# *****************************************************************************

module RicReservation
	module Concerns
		module Controllers
			module Admin
				module EventsController extend ActiveSupport::Concern

					#
					# 'included do' causes the included code to be evaluated in the
					# context where it is included, rather than being executed in 
					# the module's context.
					#
					included do
						
						before_action :set_event, only: [:show, :edit, :update, :destroy]

					end

					#
					# Show action
					#
					def show

						# Pagination
						@from, @to, @page = RicReservation.event_model.schedule_paginate(
							Date.today, 
							(@event.month_scope_period? ? "month" : "week"), 
							params[:page], true
						)

						# Load scheduled events
						@scheduled_events = RicReservation.event_model.schedule_events(@from, @to, [@event])

					end

					#
					# New Action
					#
					def new
						@event = RicReservation.event_model.new
						if params[:resource_id]
							@event.resource_id = params[:resource_id]
						end
					end

					# Edit action
					#
					def edit
					end

					#
					# Create action
					#
					def create
						@event = RicReservation.event_model.new(event_params)
						if @event.save
							redirect_to ric_reservation_admin.event_path(@event), notice: I18n.t("activerecord.notices.models.ric_reservation/event.create")
						else
							render "new"
						end
					end

					#
					# Update action
					#
					def update
						if @event.update(event_params)
							redirect_to ric_reservation_admin.event_path(@event), notice: I18n.t("activerecord.notices.models.ric_reservation/event.update")
						else
							render "edit"
						end
					end

					#
					# Destroy action
					#
					def destroy
						@event.invalidate(Date.today)
						redirect_to ric_reservation_admin.resource_path(@event.resource), notice: I18n.t("activerecord.notices.models.ric_reservation/event.destroy")
					end

				private
					
					# *********************************************************
					# STI
					# *********************************************************

					def set_type 
						@type = RicReservation.event_model.types.include?(params[:type]) ? params[:type] : RicReservation.event_model.to_s 
					end
					
					def type_model
						@type.constantize 
					end

					# *********************************************************
					# Model
					# *********************************************************

					def set_event
						@event = RicReservation.event_model.find_by_id(params[:id])
						if @event.nil?
							redirect_to root_path, alert: I18n.t("activerecord.errors.models.ric_reservation/event.not_found")
						end
					end

					# *********************************************************
					# Params
					# *********************************************************

					# 
					# Never trust parameters from the scary internet, only allow the white list through.
					#
					def event_params
						params.require(:event).permit(:resource_id, :name, :from, :to, :period, :capacity, :time_window_soon, :time_window_deadline)
					end

				end
			end
		end
	end
end