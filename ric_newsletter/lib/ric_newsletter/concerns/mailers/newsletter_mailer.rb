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
				def to_customer(newsletter, customer)
					mail(from: RicNewsletter.mailer_sender, to: customer.email, subject: newsletter.subject) do |format|
						format.html { render text: (newsletter.content + customer.newsletter_footer) }
					end
				end

			end
		end
	end
end
