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
					
						before_action :set_contact_message, only: [:show, :edit, :update, :destroy]

					end

					def index
						@contact_messages = RicContact.contact_message_model.all.order(created_at: :desc).page(params[:page]).per(50)
					end

					def show
						respond_to do |format|
							format.html { render "show" }
							format.json { render json: @contact_message.to_json }
						end
					end

					def new
						@contact_message = RicContact.contact_message_model.new
					end

					def edit
					end

					def create
						@contact_message = RicContact.contact_message_model.new(contact_message_params)
						if @contact_message.save
							respond_to do |format|
								format.html { redirect_to contact_message_path(@contact_message), notice: I18n.t("activerecord.notices.models.#{RicContact.contact_message_model.model_name.i18n_key}.create") }
								format.json { render json: @contact_message.id }
							end
						else
							respond_to do |format|
								format.html { render "new" }
								format.json { render json: @contact_message.errors }
							end
						end
					end

					def update
						if @contact_message.update(contact_message_params)
							respond_to do |format|
								format.html { redirect_to contact_message_path(@contact_message), notice: I18n.t("activerecord.notices.models.#{RicContact.contact_message_model.model_name.i18n_key}.update") }
								format.json { render json: @contact_message.id }
							end
						else
							respond_to do |format|
								format.html { render "edit" }
								format.json { render json: @contact_message.errors }
							end
						end
					end

					def destroy
						@contact_message.destroy
						respond_to do |format|
							format.html { redirect_to contact_messages_path, notice: I18n.t("activerecord.notices.models.#{RicContact.contact_message_model.model_name.i18n_key}.destroy") }
							format.json { render json: @contact_message.id }
						end
					end

				protected

					def set_contact_message
						@contact_message = RicContact.contact_message_model.find_by_id(params[:id])
						if @contact_message.nil?
							redirect_to contact_messages_path, alert: I18n.t("activerecord.errors.models.#{RicContact.contact_message_model.model_name.i18n_key}.not_found")
						end
					end

					def contact_message_params
						params.require(:contact_message).permit(RicContact.contact_message_model.permitted_columns)
					end

				end
			end
		end
	end
end
