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
			module Admin
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
						before_action :set_event, only: [:show, :edit, :update, :destroy]

					end

					#
					# Index action
					#
					def index
						@events = RicJournal.event_model.all.order(held_at: :desc).page(params[:page]).per(50)
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
						@event = RicJournal.event_model.new
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
						@event = RicJournal.event_model.new(event_params)
						if @event.save
							redirect_to ric_journal_admin.event_path(@event), notice: I18n.t("activerecord.notices.models.#{RicJournal.event_model.model_name.i18n_key}.create")
						else
							render "new"
						end
					end

					#
					# Update action
					#
					def update
						if @event.update(event_params)
							redirect_to ric_journal_admin.event_path(@event), notice: I18n.t("activerecord.notices.models.#{RicJournal.event_model.model_name.i18n_key}.update")
						else
							render "edit"
						end
					end

					#
					# Destroy action
					#
					def destroy
						@event.destroy
						redirect_to ric_journal_admin.events_path, notice: I18n.t("activerecord.notices.models.#{RicJournal.event_model.model_name.i18n_key}.destroy")
					end

				protected

					def set_event
						@event = RicJournal.event_model.find_by_id(params[:id])
						if @event.nil?
							redirect_to ric_journal_admin.events_path, alert: I18n.t("activerecord.errors.models.#{RicJournal.event_model.model_name.i18n_key}.not_found")
						end
					end

					# 
					# Never trust parameters from the scary internet, only allow the white list through.
					#
					def event_params
						params.require(:event).permit(:title, :perex, :content, :held_at)
					end

				end
			end
		end
	end
end
