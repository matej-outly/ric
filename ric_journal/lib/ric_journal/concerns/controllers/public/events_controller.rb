# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Events
# *
# * Author: Matěj Outlý
# * Date  : 31. 7. 2015
# *
# *****************************************************************************

module RicJournal
	module Concerns
		module Controllers
			module Public
				module EventsController extend ActiveSupport::Concern

					#
					# 'included do' causes the included code to be evaluated in the
					# context where it is included, rather than being executed in 
					# the module's context.
					#
					included do

						#
						# Set event before some actions
						#
						before_action :set_event, only: [:show]

					end

					#
					# Index action
					#
					def index
						@events = RicJournal.event_model.order(held_at: :desc).page(params[:page]).per(50)
					end

					#
					# Show action
					#
					def show
					end

				protected

					def set_event
						@event = RicJournal.event_model.find_by_id(params[:id])
						if @event.nil?
							redirect_to ric_journal_public.events_path, alert: I18n.t("activerecord.errors.models.#{RicJournal.event_model.model_name.i18n_key}.not_found")
						end
					end

				end
			end
		end
	end
end
