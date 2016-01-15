# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Timetables
# *
# * Author: Matěj Outlý
# * Date  : 7. 12. 2015
# *
# *****************************************************************************

module RicReservation
	module Concerns
		module Controllers
			module Public
				module TimetablesController extend ActiveSupport::Concern

					#
					# 'included do' causes the included code to be evaluated in the
					# context where it is included, rather than being executed in 
					# the module's context.
					#
					included do
						
						before_action :set_resource, only: [:show]

					end

					#
					# Index action
					#
					def index
						@resource = RicReservation.resource_model.order(position: :asc).first
						if @resource.nil?
							redirect_to main_app.root_path, alert: I18n.t("activerecord.errors.models.#{RicReservation.resource_model.model_name.i18n_key}.not_found")
							return
						end
						show
						render "show"
					end

					#
					# Show action
					#
					def show
						@today = Date.today

						# Valid events pagination
						@from, @to, @period, @page = RicReservation.event_model.schedule_paginate(@today, params[:period], params[:page])

						# Load valid events
						@events = RicReservation.event_model.schedule_events(@from, @to, @resource.events.valid(@from, @to))

						# Load valid reservations
						@reservations = RicReservation.reservation_model.resource(@resource).schedule(@from, @to)
					end

				private
	
					def set_resource
						@resource = RicReservation.resource_model.find_by_id(params[:id])
						if @resource.nil?
							redirect_to main_app.root_path, alert: I18n.t("activerecord.errors.models.#{RicReservation.resource_model.model_name.i18n_key}.not_found")
						end
					end

				end
			end
		end
	end
end
