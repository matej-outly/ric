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
						
						before_action :save_referrer, only: [:edit]
						before_action :set_notification_template, only: [:show, :edit, :update]
						before_action :create_missing_notification_templates, only: [:index]

					end

					def index
						@notification_templates = RicNotification.notification_template_model.all.order(key: :asc)
					end

					def show
					end

					def edit
					end

					def update
						if @notification_template.update(notification_template_params)
							redirect_to load_referrer, notice: I18n.t("activerecord.notices.models.#{RicNotification.notification_template_model.model_name.i18n_key}.update")
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
							redirect_to request.referrer, status: :see_other, alert: I18n.t("activerecord.errors.models.#{RicNotification.notification_template_model.model_name.i18n_key}.not_found")
						end
					end

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
