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
					@sender = RicContact.mailer_sender
					if @sender.nil?
						raise "Please specify sender."
					end
					@receiver = RicContact.mailer_receiver
					if @receiver.nil?
						raise "Please specify receiver."
					end
					@contact_message = contact_message
					mail(from: @sender, to: @receiver, subject: I18n.t("activerecord.mailers.ric_contact.contact_message.new_message.subject"))
				end

			end
		end
	end
end
