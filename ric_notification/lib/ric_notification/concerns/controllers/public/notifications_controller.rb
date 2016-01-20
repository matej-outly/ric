# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Notifications
# *
# * Author: Matěj Outlý
# * Date  : 9. 6. 2015
# *
# *****************************************************************************

module RicNotification
	module Concerns
		module Controllers
			module Public
				module NotificationsController extend ActiveSupport::Concern

					#
					# 'included do' causes the included code to be evaluated in the
					# context where it is included, rather than being executed in 
					# the module's context.
					#
					included do
					
						#
						# Set notification before some actions
						#
						before_action :set_notification, only: [:show]

					end

					#
					# Index action
					#
					def index
						@notifications = RicNotification.notification_model.search(params[:q]).order(email: :asc)
						respond_to do |format|
							format.html { render "index" }
							format.json { render json: @notifications.to_json }
						end
					end

					#
					# Show action
					#
					def show
						respond_to do |format|
							format.html { render "show" }
							format.json { render json: @notification }
						end
					end

				protected

					def set_notification
						@notification = RicNotification.notification_model.find_by_id(params[:id])
						if @notification.nil?
							redirect_to notifications_path, error: I18n.t("activerecord.errors.models.#{RicNotification.notification_model.model_name.i18n_key}.not_found")
						end
					end

				end
			end
		end
	end
end
