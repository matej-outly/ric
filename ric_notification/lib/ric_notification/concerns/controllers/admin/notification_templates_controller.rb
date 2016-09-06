# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Notification templates
# *
# * Author: Matěj Outlý
# * Date  : 9. 5. 2016
# *
# *****************************************************************************

module RicNotification
	module Concerns
		module Controllers
			module Admin
				module NotificationTemplatesController extend ActiveSupport::Concern

					#
					# 'included do' causes the included code to be evaluated in the
					# context where it is included, rather than being executed in 
					# the module's context.
					#
					included do
					
						#
						# Set notification before some actions
						#
						before_action :set_notification_template, only: [:show, :edit, :update]
						before_action :create_missing_notification_templates, only: [:index]

					end

					#
					# Index action
					#
					def index
						@notification_templates = RicNotification.notification_template_model.all.order(key: :asc)
					end

					#
					# Show action
					#
					def show
					end

					#
					# Edit action
					#
					def edit
					end

					#
					# Update action
					#
					def update
						if @notification_template.update(notification_template_params)
							redirect_to notification_template_path(@notification_template), notice: I18n.t("activerecord.notices.models.#{RicNotification.notification_template_model.model_name.i18n_key}.update")
						else
							render "edit"
						end
					end

				protected

					def create_missing_notification_templates
						RicNotification.notification_template_model.config(:keys).each do |key|
							notification_template = RicNotification.notification_template_model.where(key: key).first
							if notification_template.nil?
								notification_template = RicNotification.notification_template_model.create(key: key)
							end
						end
					end

					def set_notification_template
						@notification_template = RicNotification.notification_template_model.find_by_id(params[:id])
						if @notification_template.nil?
							redirect_to notification_templates_path, error: I18n.t("activerecord.errors.models.#{RicNotification.notification_template_model.model_name.i18n_key}.not_found")
						end
					end

					# 
					# Never trust parameters from the scary internet, only allow the white list through.
					#
					def notification_template_params
						params.require(:notification_template).permit(
							#:description,
							:subject,
							:message,
						)
					end

				end
			end
		end
	end
end
