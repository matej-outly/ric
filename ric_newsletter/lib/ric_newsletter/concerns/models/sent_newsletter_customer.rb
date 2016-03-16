# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Sent newsletter
# *
# * Author: Matěj Outlý
# * Date  : 17. 2. 2015
# *
# *****************************************************************************

module RicNewsletter
	module Concerns
		module Models
			module SentNewsletterCustomer extend ActiveSupport::Concern

				#
				# 'included do' causes the included code to be evaluated in the
				# context where it is included, rather than being executed in 
				# the module's context.
				#
				included do
					
					# *********************************************************************
					# Structure
					# *********************************************************************

					#
					# Relation to newsletter
					#
					belongs_to :sent_newsletter, class_name: RicNewsletter.sent_newsletter_model.to_s

					#
					# Relation to customer
					#
					belongs_to :customer, class_name: RicNewsletter.customer_model.to_s

				end

				#
				# Send given newsletter
				#
				def send_newsletter(newsletter)

					if newsletter.nil?
						return false
					end

					# Send email to customer
					begin 
						RicNewsletter::NewsletterMailer.to_customer(newsletter, self.customer).deliver_now
						self.success = true
					#rescue Net::SMTPFatalError, Net::SMTPSyntaxError
					rescue Exception => e
						self.success = false
						self.error_message = e.message
					end
				
					# Mark as sent
					self.sent_at = Time.current

					# Save
					self.save

					return true
				end

			end
		end
	end
end