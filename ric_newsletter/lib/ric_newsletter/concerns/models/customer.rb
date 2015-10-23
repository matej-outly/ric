# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Customer
# *
# * Author: Matěj Outlý
# * Date  : 22. 10. 2015
# *
# *****************************************************************************

module RicNewsletter
	module Concerns
		module Models
			module Customer extend ActiveSupport::Concern

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
					# Relation to sent newsletters
					#
					has_many :sent_newsletter_customers, class_name: RicNewsletter.sent_newsletter_customer_model.to_s, dependent: :destroy
					has_many :sent_newsletters, class_name: RicNewsletter.sent_newsletter_customer_model.to_s, through: :sent_newsletter_customers

					# *********************************************************************
					# Validators
					# *********************************************************************

					#
					# E-mail must be set
					#
					validates :email, presence: true, uniqueness: true

				end

				module ClassMethods
					
					# *********************************************************************
					# Scopes
					# *********************************************************************

					def newsletter_enabled
						where(enable_newsletter: true)
					end

					# *********************************************************************
					# Sign up / sign out
					# *********************************************************************

					#
					# Create new customer with given e-mail or find existing one and enable newsletters for this customer
					#
					def newsletter_sign_up(email, newsletter_token = nil)
						if email.blank?
							return nil
						end
						result = nil
						ActiveRecord::Base.transaction do
							customer = RicNewsletter.customer_model.where(email: email).first
							if customer
								#if customer.newsletter_token == newsletter_token
									customer.enable_newsletter = true
									customer.save
									result = customer
								#end
							else
								newsletter_token = RugSupport::Util::String.random(64)
								customer = RicNewsletter.customer_model.create(email: email, enable_newsletter: true, newsletter_token: newsletter_token)
								result = customer
							end
						end
						return result
					end

					#
					# Find customer according to given email and disable newsletters for this customer
					#
					def newsletter_sign_out(email, newsletter_token)
						if email.blank?
							return nil
						end
						result = nil
						ActiveRecord::Base.transaction do
							customer = RicNewsletter.customer_model.where(email: email).first
							if customer
								if customer.newsletter_token == newsletter_token
									customer.enable_newsletter = false
									customer.save
									result = customer
								end
							end
						end
						return result
					end	

				end

				#
				# Get personalised newsletter footer
				#
				def newsletter_footer
					sign_out_url = RicNewsletter::PublicEngine.routes.url_helpers.newsletter_sign_out_customers_url(host: Rails.application.config.action_mailer.default_url_options[:host], email: self.email, token: self.newsletter_token)
					return I18n.t("activerecord.attributes.ric_customer/customer.newsletter_footer_value", sign_out_url: sign_out_url)
				end

			end
		end
	end
end