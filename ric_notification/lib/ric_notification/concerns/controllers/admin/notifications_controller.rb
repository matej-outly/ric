# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Notifications
# *
# * Author: Matěj Outlý
# * Date  : 21. 1. 2016
# *
# *****************************************************************************

module RicNotification
	module Concerns
		module Controllers
			module Admin
				module NotificationsController extend ActiveSupport::Concern

					#
					# 'included do' causes the included code to be evaluated in the
					# context where it is included, rather than being executed in 
					# the module's context.
					#
					included do
					
						before_action :set_notification, only: [:show, :deliver, :destroy]

					end

					def index
						@notifications = RicNotification.notification_model.all.order(created_at: :desc).page(params[:page]).per(50)
					end

					def show
					end

					def deliver
						@notification.enqueue_for_delivery
						redirect_to request.referrer, notice: I18n.t("activerecord.notices.models.#{RicNotification.notification_model.model_name.i18n_key}.enqueue_for_delivery")
					end

					def destroy
						@notification.destroy
						redirect_to notifications_path, notice: I18n.t("activerecord.notices.models.#{RicNotification.notification_model.model_name.i18n_key}.destroy")
					end

				protected

					def set_notification
						@notification = RicNotification.notification_model.find_by_id(params[:id])
						if @notification.nil?
							redirect_to request.referrer, status: :see_other, alert: I18n.t("activerecord.errors.models.#{RicNotification.notification_model.model_name.i18n_key}.not_found")
						end
					end

				end
			end
		end
	end
end
