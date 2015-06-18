# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Customers
# *
# * Author: Matěj Outlý
# * Date  : 16. 12. 2014
# *
# *****************************************************************************

module RicCustomer
	module Concerns
		module Controllers
			module Admin
				module CustomersController extend ActiveSupport::Concern

					#
					# 'included do' causes the included code to be evaluated in the
					# context where it is included, rather than being executed in 
					# the module's context.
					#
					included do
					
						#
						# Set customer before some actions
						#
						before_action :set_customer, only: [:show, :edit, :update, :destroy]

						#
						# Set statistic before some actions
						#
						before_action :set_statistic, only: [:statistic, :statistic_search]

					end

					#
					# Index action
					#
					def index
						@search_customer = RicCustomer.customer_model.new(load_params_from_session)
						@customers = RicCustomer.customer_model.search(load_params_from_session.symbolize_keys).order(last_name: :asc, first_name: :asc)
						if request.format.to_sym == :html
							@customers = @customers.page(params[:page])
						end

						respond_to do |format|
							format.html
							format.xls
						end
					end

					#
					# Index/search action
					#
					def index_search
						save_params_to_session(index_search_params)
						redirect_to customers_path
					end

					#
					# Scope/search action
					#
					def statistic
						@search_customer = RicCustomer.customer_model.new(load_params_from_session)
						@customers = RicCustomer.customer_model.send(@statistic, load_params_from_session.symbolize_keys)
					end

					#
					# Scope/search action
					#
					def statistic_search
						save_params_to_session(statistic_search_params)
						redirect_to statistic_customers_path
					end

					#
					# Show action
					#
					def show
					end

					#
					# New action
					#
					def new
						@customer = RicCustomer.customer_model.new
					end

					#
					# Edit action
					#
					def edit
					end

					#
					# Create action
					#
					def create
						@customer = RicCustomer.customer_model.new(customer_params)
						if @customer.save
							redirect_to customer_path(@customer), notice: I18n.t("activerecord.notices.models.#{RicCustomer.customer_model.model_name.i18n_key}.create")
						else
							render "new"
						end
					end

					#
					# Update action
					#
					def update
						if @customer.update(customer_params)
							redirect_to customer_path(@customer), notice: I18n.t("activerecord.notices.models.#{RicCustomer.customer_model.model_name.i18n_key}.update")
						else
							render "edit"
						end
					end

					#
					# Destroy action
					#
					def destroy
						@customer.destroy
						redirect_to customers_path, notice: I18n.t("activerecord.notices.models.#{RicCustomer.customer_model.model_name.i18n_key}.destroy")
					end

				protected

					# *********************************************************************
					# Model setters
					# *********************************************************************
					
					def set_customer
						@customer = RicCustomer.customer_model.find_by_id(params[:id])
						if @customer.nil?
							redirect_to customers_path, alert: I18n.t("activerecord.errors.models.#{RicCustomer.customer_model.model_name.i18n_key}.not_found")
						end
					end

					def set_statistic
						@statistic = params[:statistic].to_sym
						if !RicCustomer.customer_model.respond_to?(@statistic) || !RicCustomer.customer_model.respond_to?("#{@statistic.to_s}_columns".to_sym)
							redirect_to customers_path, alert: I18n.t("activerecord.errors.models.#{RicCustomer.customer_model.model_name.i18n_key}.statistic_not_found")
							return
						end
						@statistic_columns = RicCustomer.customer_model.send("#{@statistic.to_s}_columns".to_sym)
					end

					# *********************************************************************
					# Session
					# *********************************************************************

					def session_key
						return "customers"
					end

					def save_params_to_session(params)
						if session[session_key].nil?
							session[session_key] = {}
						end
						if !params.nil?
							session[session_key]["params"] = params
						end		
					end

					def load_params_from_session
						if !session[session_key].nil? && !session[session_key]["params"].nil?
							return session[session_key]["params"]
						else
							return {}
						end
					end

					# *********************************************************************
					# Param filters
					# *********************************************************************

					# 
					# Never trust parameters from the scary internet, only allow the white list through.
					#
					def customer_params
						params.require(:customer).permit(:first_name, :last_name, :email, :phone)
					end

					def statistic_search_params
						return params[:customer].permit(@statistic_columns)
					end

					def index_search_params
						return params[:customer].permit(RicCustomer.customer_model.search_columns)
					end

				end
			end
		end
	end
end
