# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Customers
# *
# * Author: Matěj Outlý
# * Date  : 22. 10. 2015
# *
# *****************************************************************************

module RicNewsletter
	module Concerns
		module Controllers
			module Public
				module CustomersController extend ActiveSupport::Concern

					#
					# 'included do' causes the included code to be evaluated in the
					# context where it is included, rather than being executed in 
					# the module's context.
					#
					included do
					
					end

					#
					# Index action
					#
					def index
					end

					#
					# Sign up for newsletter
					#
					def newsletter_sign_up
						customer = RicNewsletter.customer_model.newsletter_sign_up(customers_params[:email])
						if customer
							respond_to do |format|
								format.html { redirect_to ric_newsletter_public.customers_path, notice: I18n.t("activerecord.notices.models.#{RicNewsletter.customer_model.model_name.i18n_key}.newsletter_sign_up") }
								format.json { render json: true }
							end
						else
							respond_to do |format|
								format.html { redirect_to ric_newsletter_public.customers_path, notice: I18n.t("activerecord.errors.models.#{RicNewsletter.customer_model.model_name.i18n_key}.newsletter_sign_up") }
								format.json { render json: false }
							end
						end
					end

					#
					# Sign out from newsletter
					#
					def newsletter_sign_out
						customer = RicNewsletter.customer_model.newsletter_sign_out(params[:email], params[:token])
						if customer
							respond_to do |format|
								format.html { redirect_to ric_newsletter_public.customers_path, notice: I18n.t("activerecord.notices.models.#{RicNewsletter.customer_model.model_name.i18n_key}.newsletter_sign_out") }
								format.json { render json: true }
							end
						else
							respond_to do |format|
								format.html { redirect_to ric_newsletter_public.customers_path, notice: I18n.t("activerecord.errors.models.#{RicNewsletter.customer_model.model_name.i18n_key}.newsletter_sign_out") }
								format.json { render json: false }
							end
						end
					end

				protected

					# *********************************************************************
					# Param filters
					# *********************************************************************

					# 
					# Never trust parameters from the scary internet, only allow the white list through.
					#
					def customers_params
						params.require(:customer).permit(:email)
					end

				end
			end
		end
	end
end
