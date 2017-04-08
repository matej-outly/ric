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
					params = {}
					
					# Subject
					params[:subject] = I18n.t("activerecord.mailers.ric_contact.contact_message.new_message.subject")
					
					# Sender
					params[:from] = RicContact.mailer_sender
					raise "Please specify sender." if params[:from].nil?
					if !RicContact.mailer_sender_name.blank?
						params[:from] = "#{RicContact.mailer_sender_name} <#{params[:from]}>"
					end

					# Receiver
					params[:to] = RicContact.mailer_receiver
					raise "Please specify receiver." if params[:to].nil?

					# Copy for author
					params[:bcc] = contact_message.email if RicContact.send_contact_messages_copy_to_author && contact_message.respond_to?(:email) && !contact_message.email.blank?
					
					mail(params)
				end

				def notify_message(contact_message)
					@contact_message = contact_message
					params = {}
					
					# Subject
					params[:subject] = I18n.t("activerecord.mailers.ric_contact.contact_message.notify_message.subject")
					
					# Sender
					params[:from] = RicContact.mailer_sender
					raise "Please specify sender." if params[:from].nil?
					if !RicContact.mailer_sender_name.blank?
						params[:from] = "#{RicContact.mailer_sender_name} <#{params[:from]}>"
					end
					
					# Receiver
					raise "Contect message model must respond to email attribute" if !contact_message.respond_to?(:email) 
					return if contact_message.email.blank?
					params[:to] = contact_message.email 

					mail(params)
				end

			end
		end
	end
end
