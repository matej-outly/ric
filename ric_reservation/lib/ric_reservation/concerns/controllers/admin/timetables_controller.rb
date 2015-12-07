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
			module Admin
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
						@resources = RicReservation.resource_model.all.order(position: :asc)
					end

					#
					# Show action
					#
					def show

						# Pagination
						@from, @to, @page = RicReservation.event_model.schedule_paginate(Date.today, "week", params[:page])

						# Load
						@events = RicReservation.event_model.schedule_events(@from, @to, RicReservation.event_model.valid(@from, @to).where(resource_id: @resource.id))

					end

				private
	
					def set_resource
						@resource = RicReservation.resource_model.find_by_id(params[:id])
						if @resource.nil?
							redirect_to root_path, alert: I18n.t("activerecord.errors.models.ric_reservation/resource.not_found")
						end
					end

				end
			end
		end
	end
end
