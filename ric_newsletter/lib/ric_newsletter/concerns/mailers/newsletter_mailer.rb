# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Newsletter mailer
# *
# * Author: Matěj Outlý
# * Date  : 17. 2. 2015
# *
# *****************************************************************************

module RicNewsletter
	module Concerns
		module Mailers
			module NewsletterMailer extend ActiveSupport::Concern

				#
				# Main function for sending newsletters to customers
				#
				def to_customer(newsletter, customer_email)
					mail(to: customer_email, subject: newsletter.subject) do |format|
						format.html { render text: newsletter.content }
					end
				end

			end
		end
	end
end
