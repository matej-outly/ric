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
					
						#
						# Set notification before some actions
						#
						before_action :set_notification, only: [:show, :edit, :update, :deliver, :destroy]

					end

					#
					# Index action
					#
					def index
						@notifications = RicNotification.notification_model.all.order(created_at: :desc).page(params[:page]).per(50)
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
						@notification = RicNotification.notification_model.new
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
						@notification = RicNotification.notification_model.new(notification_params)
						@notification.author = current_user
						if @notification.save
							redirect_to notification_path(@notification), notice: I18n.t("activerecord.notices.models.#{RicNotification.notification_model.model_name.i18n_key}.create")
						else
							render "new"
						end
					end

					#
					# Update action
					#
					def update
						if @notification.update(notification_params)
							redirect_to notification_path(@notification), notice: I18n.t("activerecord.notices.models.#{RicNotification.notification_model.model_name.i18n_key}.update")
						else
							render "edit"
						end
					end

					#
					# Deliver action
					#
					def deliver
						@notification.enqueue_for_delivery
						redirect_to notification_path(@notification), notice: I18n.t("activerecord.notices.models.#{RicNotification.notification_model.model_name.i18n_key}.enqueue_for_delivery")
					end

					#
					# Destroy action
					#
					def destroy
						@notification.destroy
						redirect_to notifications_path, notice: I18n.t("activerecord.notices.models.#{RicNotification.notification_model.model_name.i18n_key}.destroy")
					end

				protected

					def set_notification
						@notification = RicNotification.notification_model.find_by_id(params[:id])
						if @notification.nil?
							redirect_to notifications_path, error: I18n.t("activerecord.errors.models.#{RicNotification.notification_model.model_name.i18n_key}.not_found")
						end
					end

					# 
					# Never trust parameters from the scary internet, only allow the white list through.
					#
					def notification_params
						params.require(:notification).permit(
							:subject, 
							:message, 
							:kind, 
							:url, 
							:receiver_id
						)
					end

				end
			end
		end
	end
end
