# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Exceptions
# *
# * Author: Matěj Outlý
# * Date  : 7. 7. 2017
# *
# *****************************************************************************

module RicException
	module Concerns
		module Controllers
			module ExceptionsController extend ActiveSupport::Concern

				def not_found
					render :status => 404
				end

				def unacceptable
					render :status => 422
				end

				def internal_error
					notify_exception
					render :status => 500
				end
				
			protected

				def notify_exception
					exception = env["action_dispatch.exception"]
					if exception && RicException.mailer_sender && RicException.mailer_receiver
						begin 
							RicException::ExceptionMailer.notify(exception).deliver_now
						rescue StandardError => e
							# Unfortunatelly nothing can be done except ignoring the error...
						end
					end
				end

			end
		end
	end
end
