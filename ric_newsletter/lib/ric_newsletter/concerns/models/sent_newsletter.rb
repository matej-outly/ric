# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Sent newsletter
# *
# * Author: Matěj Outlý
# * Date  : 16. 2. 2015
# *
# *****************************************************************************

module RicNewsletter
	module Concerns
		module Models
			module SentNewsletter extend ActiveSupport::Concern

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
					belongs_to :newsletter, class_name: RicNewsletter.newsletter_model.to_s

					#
					# Relation to sent newsletters
					#
					has_many :sent_newsletter_customers, class_name: RicNewsletter.sent_newsletter_customer_model.to_s, dependent: :destroy

				end

				module ClassMethods

					def init_send(id)
						
						# Find object
						sent_newsletter = self.find_by_id(id)
						if sent_newsletter.nil?
							return nil
						end

						# Find scope method
						if !RicNewsletter.customer_model.respond_to?(sent_newsletter.customers_scope.to_sym)
							return nil
						end
						scope_method = RicNewsletter.customer_model.method(sent_newsletter.customers_scope.to_sym)
						
						# Get optional scope params
						if sent_newsletter.customers_scope_params.blank? || sent_newsletter.customers_scope_params == "null"
							scope_params = nil
						else
							scope_params = JSON.parse(sent_newsletter.customers_scope_params)
							if !scope_params.is_a? Hash
								return nil
							end
							scope_params = scope_params.symbolize_keys
						end

						# Call scope method to get customer collection
						if scope_params
							customers = scope_method.call(scope_params)
						else
							customers = scope_method.call
						end
						if customers.nil?
							return nil
						end

						# Destroy all associated customer bindings
						sent_newsletter.sent_newsletter_customers.clear

						# Create newsletter customers
						customers.each do |customer|
							sent_newsletter.sent_newsletter_customers.create(customer_id: customer.id, customer_email: customer.email)
						end

						# Update statistics
						sent_newsletter.customers_count = customers.size
						sent_newsletter.sent_count = 0
						sent_newsletter.save

						return sent_newsletter.customers_count
					end

					def send_batch(id, batch_size = 10)

						# Find object
						sent_newsletter = self.find_by_id(id)
						if sent_newsletter.nil?
							return nil
						end

						# Nothing to do
						if sent_newsletter.sent_count == sent_newsletter.customers_count
							return 0
						end

						# Get batch of newsletter customers prepared for send
						sent_newsletter_customers = sent_newsletter.sent_newsletter_customers.where(sent_at: nil).limit(batch_size)
						
						# Send entire batch
						sent_counter = 0
						sent_newsletter_customers.each do |sent_newsletter_customer|
							if sent_newsletter_customer.send_newsletter(sent_newsletter.newsletter)
								sent_counter += 1
							end
						end

						# Update statistics
						sent_newsletter.sent_count += sent_counter
						if sent_newsletter.sent_count == sent_newsletter.customers_count
							sent_newsletter.sent_at = Time.current
						end

						# Save
						sent_newsletter.save

						return (sent_newsletter.customers_count - sent_newsletter.sent_count)
					end

					def enqueue(id)
						QC.enqueue("RicNewsletter::SentNewsletter.init_send_and_enqueue", id)
					end

					def init_send_and_enqueue(id)

						# Init
						remaining = init_send(id)
						if remaining.nil?
							return nil
						end

						# If still some customers remaining, enqueue next batch
						if remaining > 0
							QC.enqueue("RicNewsletter::SentNewsletter.send_batch_and_enqueue", id)
							return false
						else
							return true
						end

					end

					def send_batch_and_enqueue(id, batch_size = 10)

						# Send single batch
						remaining = send_batch(id, batch_size)
						if remaining.nil?
							return nil
						end

						# If still some customers remaining, enqueue next batch
						if remaining > 0
							QC.enqueue("RicNewsletter::SentNewsletter.send_batch_and_enqueue", id, batch_size)
							return false
						else
							return true
						end

					end

				end

				def enqueue
					self.class.enqueue(self.id)
				end

			end
		end
	end
end