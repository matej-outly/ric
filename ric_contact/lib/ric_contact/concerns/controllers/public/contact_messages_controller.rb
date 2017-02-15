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
			module Public
				module ContactMessagesController extend ActiveSupport::Concern

					#
					# 'included do' causes the included code to be evaluated in the
					# context where it is included, rather than being executed in 
					# the module's context.
					#
					included do

					end

					def create
						@contact_message = RicContact.contact_message_model.new(contact_message_params)
						if validate_recaptcha && @contact_message.save
							respond_to do |format|
								format.html { redirect_to request.referrer, notice: I18n.t("activerecord.notices.models.#{RicContact.contact_message_model.model_name.i18n_key}.create") }
								format.json { render json: @contact_message.id }
							end
						else
							respond_to do |format|
								format.html { redirect_to request.referrer, alert: I18n.t("activerecord.errors.models.#{RicContact.contact_message_model.model_name.i18n_key}.create") }
								format.json { render json: @contact_message.errors }
							end
						end
					end

				protected

					def contact_message_params
						params.require(:contact_message).permit(RicContact.contact_message_model.permitted_columns)
					end

					def validate_recaptcha
						if RicContact.recaptcha == true
							verify_recaptcha(model: @contact_message, attribute: RicContact.recaptcha_attribute)
						else
							return true
						end
					end

				end
			end
		end
	end
end
