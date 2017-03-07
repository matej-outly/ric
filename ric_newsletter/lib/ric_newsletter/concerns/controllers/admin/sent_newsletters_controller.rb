# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Newsletters
# *
# * Author: Matěj Outlý
# * Date  : 16. 2. 2015
# *
# *****************************************************************************

module RicNewsletter
	module Concerns
		module Controllers
			module Admin
				module SentNewslettersController extend ActiveSupport::Concern

					#
					# 'included do' causes the included code to be evaluated in the
					# context where it is included, rather than being executed in 
					# the module's context.
					#
					included do
					
						#
						# Set newsletter before some actions
						#
						before_action :set_sent_newsletter, only: [:destroy, :resend]

						#
						# Set customers and customers scope before some actions
						#
						before_action :set_customers, only: [:new, :create]

					end

					def new
						@sent_newsletter = RicNewsletter.sent_newsletter_model.new
					end

					def create
						@sent_newsletter = RicNewsletter.sent_newsletter_model.new(sent_newsletter_params)
						@sent_newsletter.customers_scope = @customers_scope.to_s
						@sent_newsletter.customers_scope_params = @customers_scope_params.to_json
						if @sent_newsletter.save
							@sent_newsletter.enqueue
							redirect_to newsletter_path(@sent_newsletter.newsletter), notice: I18n.t("activerecord.notices.models.#{RicNewsletter.sent_newsletter_model.model_name.i18n_key}.create")
						else
							render "new"
						end
					end

					def destroy
						@sent_newsletter.destroy
						redirect_to newsletter_path(@sent_newsletter.newsletter), notice: I18n.t("activerecord.notices.models.#{RicNewsletter.sent_newsletter_model.model_name.i18n_key}.destroy")
					end

					def resend
						@sent_newsletter.enqueue
						redirect_to newsletter_path(@sent_newsletter.newsletter), notice: I18n.t("activerecord.notices.models.#{RicNewsletter.sent_newsletter_model.model_name.i18n_key}.create")
					end

				protected

					# *********************************************************************
					# Model setters
					# *********************************************************************
					
					def set_sent_newsletter
						@sent_newsletter = RicNewsletter.sent_newsletter_model.find_by_id(params[:id])
						if @sent_newsletter.nil?
							redirect_to newsletters_path, alert: I18n.t("activerecord.errors.models.#{RicNewsletter.sent_newsletter_model.model_name.i18n_key}.not_found")
						end
					end

					def set_customers
						@customers_scope = params[:customers_scope]
						if !@customers_scope || !RicNewsletter.customer_model.respond_to?(@customers_scope.to_sym)
							redirect_to newsletters_path, alert: I18n.t("activerecord.errors.models.#{RicNewsletter.sent_newsletter_model.model_name.i18n_key}.scope_not_found")
							return
						end
						if params[:customers_scope_params] && session[params[:customers_scope_params]]
							@customers_scope_params = session[params[:customers_scope_params]]["params"]
						else
							@customers_scope_params = nil
						end
						
						if @customers_scope
							if @customers_scope_params
								@customers = RicNewsletter.customer_model.method(@customers_scope.to_sym).call(@customers_scope_params.symbolize_keys)
							else
								@customers = RicNewsletter.customer_model.method(@customers_scope.to_sym).call
							end
							if @customers.respond_to?(:newsletter_enabled) # Active record collection is returned from filter
								@customers = @customers.newsletter_enabled
							else # Array is returned from filter
								new_customers = []
								@customers.each do |customer|
									if customer.respond_to?(:enable_newsletter) && customer.enable_newsletter == true
										new_customers << customer
									end
								end
								@customers = new_customers
							end
						end
					end

					# *********************************************************************
					# Param filters
					# *********************************************************************

					# 
					# Never trust parameters from the scary internet, only allow the white list through.
					#
					def sent_newsletter_params
						params.require(:sent_newsletter).permit(:newsletter_id)
					end

				end
			end
		end
	end
end
