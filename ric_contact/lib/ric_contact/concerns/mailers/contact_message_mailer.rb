# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Contact message mailer
# *
# * Author: Matěj Outlý
# * Date  : 19. 1. 2017
# *
# *****************************************************************************

module RicContact
	module Concerns
		module Mailers
			module ContactMessageMailer extend ActiveSupport::Concern

				def new_message(contact_message)
					@contact_message = contact_message
					
					# Params
					params = {}
					params[:subject] = I18n.t("activerecord.mailers.ric_contact.contact_message.new_message.subject")
					
					# Sender
					params[:from] = RicContact.mailer_sender
					if params[:from].nil?
						raise "Please specify sender."
					end

					# Receiver
					params[:to] = RicContact.mailer_receiver
					if params[:to].nil?
						raise "Please specify receiver."
					end

					# Copy for author
					if RicContact.send_contact_messages_copy_to_author && contact_message.respond_to?(:email) && !contact_message.email.blank?
						params[:bcc] = contact_message.email
					end

					mail(params)
				end

			end
		end
	end
end
