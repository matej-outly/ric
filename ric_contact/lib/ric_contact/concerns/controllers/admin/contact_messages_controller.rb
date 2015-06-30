# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Contact messages
# *
# * Author: Matěj Outlý
# * Date  : 30. 6. 2015
# *
# *****************************************************************************

module RicContact
	module Concerns
		module Controllers
			module Admin
				module ContactMessagesController extend ActiveSupport::Concern

					#
					# 'included do' causes the included code to be evaluated in the
					# context where it is included, rather than being executed in 
					# the module's context.
					#
					included do
					
						#
						# Set contact_message before some actions
						#
						before_action :set_contact_message, only: [:show, :edit, :update, :destroy]

					end

					#
					# Index action
					#
					def index
						@contact_messages = RicContact.contact_message_model.all.order(created_at: :desc).page(params[:page]).per(50)
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
						@contact_message = RicContact.contact_message_model.new
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
						@contact_message = RicContact.contact_message_model.new(contact_message_params)
						if @contact_message.save
							redirect_to contact_message_path(@contact_message), notice: I18n.t("activerecord.notices.models.#{RicContact.contact_message_model.model_name.i18n_key}.create")
						else
							render "new"
						end
					end

					#
					# Update action
					#
					def update
						if @contact_message.update(contact_message_params)
							redirect_to contact_message_path(@contact_message), notice: I18n.t("activerecord.notices.models.#{RicContact.contact_message_model.model_name.i18n_key}.update")
						else
							render "edit"
						end
					end

					#
					# Destroy action
					#
					def destroy
						@contact_message.destroy
						redirect_to contact_messages_path, notice: I18n.t("activerecord.notices.models.#{RicContact.contact_message_model.model_name.i18n_key}.destroy")
					end

				protected

					def set_contact_message
						@contact_message = RicContact.contact_message_model.find_by_id(params[:id])
						if @contact_message.nil?
							redirect_to contact_messages_path, alert: I18n.t("activerecord.errors.models.#{RicContact.contact_message_model.model_name.i18n_key}.not_found")
						end
					end

					# 
					# Never trust parameters from the scary internet, only allow the white list through.
					#
					def contact_message_params
						params.require(:contact_message).permit(:name, :email, :message)
					end

				end
			end
		end
	end
end
