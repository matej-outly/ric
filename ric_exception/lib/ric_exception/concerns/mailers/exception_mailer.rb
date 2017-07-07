# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Exception mailer
# *
# * Author: Matěj Outlý
# * Date  : 7. 7. 2017
# *
# *****************************************************************************

module RicException
	module Concerns
		module Mailers
			module ExceptionMailer extend ActiveSupport::Concern

				def notify(exception)
					
					# Sender
					@sender = RicException.mailer_sender
					if @sender.nil?
						raise "Please specify sender."
					end

					# Receiver
					@receiver = RicException.mailer_receiver
					if @receiver.nil?
						raise "Please specify receiver."
					end

					# Other view data
					@exception = exception
					
					# Subject
					subject = "#{main_app.root_url}: #{@exception.message}"
					
					# Mail
					mail(from: @sender, to: @receiver, subject: subject)
				end

			end
		end
	end
end
