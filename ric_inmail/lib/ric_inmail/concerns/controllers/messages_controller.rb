# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Messages
# *
# * Author: Matěj Outlý
# * Date  : 19. 2. 2017
# *
# *****************************************************************************

module RicInmail
	module Concerns
		module Controllers
			module MessagesController extend ActiveSupport::Concern

				#
				# 'included do' causes the included code to be evaluated in the
				# context where it is included, rather than being executed in 
				# the module's context.
				#
				included do

					before_action :save_referrer, only: [:new]
					before_action :set_owner
					before_action :set_in_message, only: [:show, :destroy]
					before_action :set_template, only: [:new]

				end

				def index
					raise "Not implemented yet."
				end

				def show
				end

				def new
					@in_message = RicInmail.in_message_model.new
					@in_message.template = @template
				end

				def create
					@in_message = RicInmail.in_message_model.new(in_message_params)
					@in_message.owner = @owner
					@in_message.sender = @owner
					if @in_message.save
						@in_message.deliver
						redirect_url = load_referrer
						redirect_url = ric_inmail.messages_path if redirect_url.blank?
						redirect_to redirect_url, notice: I18n.t("activerecord.notices.models.#{RicInmail.in_message_model.model_name.i18n_key}.deliver")
					else
						render "new"
					end	
				end

				def destroy
					@in_message.destroy
					redirect_url = ric_inmail.messages_path
					redirect_to redirect_url, notice: I18n.t("activerecord.notices.models.#{RicInmail.in_message_model.model_name.i18n_key}.destroy")
				end

			protected

				# *************************************************************
				# Model setters
				# *************************************************************

				def set_in_message
					@in_message = RicInmail.in_message_model.find_by_id(params[:id])
					if @in_message.nil? || @in_message.owner_type != @owner.class.name || @in_message.owner_id != @owner.id
						redirect_to request.referrer, status: :see_other, alert: I18n.t("activerecord.errors.models.#{RicInmail.in_message_model.model_name.i18n_key}.not_found")
					end
				end

				def set_template
					if !params[:template_type].blank? && !params[:template_id].blank?
						begin
							@template = params[:template_type].constantize.find_by_id(params[:template_id])
						rescue NameError
						end
					end
				end

				def set_owner
					if RicInmail.use_person
						@owner = current_user.person
					else
						@owner = current_user
					end
				end

				# *************************************************************
				# Param filters
				# *************************************************************

				def in_message_params
					result = params.require(:in_message).permit(RicInmail.in_message_model.permitted_columns)
					result[:receivers_selector_values] = result[:receivers_selector_values].split(",") if !result[:receivers_selector_values].blank?
					return result
				end

			end
		end
	end
end