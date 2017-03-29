# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Prices
# *
# * Author: Matěj Outlý
# * Date  : 29. 3. 2017
# *
# *****************************************************************************

module RicPricing
	module Concerns
		module Controllers
			module Admin
				module PricesController extend ActiveSupport::Concern

					#
					# 'included do' causes the included code to be evaluated in the
					# context where it is included, rather than being executed in 
					# the module's context.
					#
					included do
						
						before_action :save_referrer, only: [:new, :edit]
						before_action :set_price_list
						before_action :set_price, only: [:show, :edit, :update, :move, :destroy]

					end

					def new
						@price = RicPricing.price_model.new
						@price.price_list_id = @price_list.id
					end

					def edit
					end

					def create
						@price = RicPricing.price_model.new(price_params)
						@price.price_list_id = @price_list.id
						if @price.save
							respond_to do |format|
								format.html { redirect_to load_referrer, notice: I18n.t("activerecord.notices.models.#{RicPricing.price_model.model_name.i18n_key}.create") }
								format.json { render json: @price.id }
							end
						else
							respond_to do |format|
								format.html { render "new" }
								format.json { render json: @price.errors }
							end
						end
					end

					def update
						if @price.update(price_params)
							respond_to do |format|
								format.html { redirect_to load_referrer, notice: I18n.t("activerecord.notices.models.#{RicPricing.price_model.model_name.i18n_key}.update") }
								format.json { render json: @price.id }
							end
						else
							respond_to do |format|
								format.html { render "edit" }
								format.json { render json: @price.errors }
							end
						end
					end

					def move
						if RicPricing.price_model.move(params[:id], params[:relation], params[:destination_id])
							respond_to do |format|
								format.html { redirect_to request.referrer, notice: I18n.t("activerecord.notices.models.#{RicPricing.price_model.model_name.i18n_key}.move") }
								format.json { render json: true }
							end
						else
							respond_to do |format|
								format.html { redirect_to request.referrer, alert: I18n.t("activerecord.errors.models.#{RicPricing.price_model.model_name.i18n_key}.move") }
								format.json { render json: false }
							end
						end
					end
					
					def destroy
						@price.destroy
						respond_to do |format|
							format.html { redirect_to ric_pricing_admin.prices_path, notice: I18n.t("activerecord.notices.models.#{RicPricing.price_model.model_name.i18n_key}.destroy") }
							format.json { render json: @price.id }
						end
					end

				protected

					def set_price_list
						@price_list = RicPricing.price_list_model.find_by_id(params[:price_list_id])
						if @price_list.nil?
							redirect_to request.referrer, alert: I18n.t("activerecord.errors.models.#{RicPricing.price_model.model_name.i18n_key}.not_found")
						end
					end

					def set_price
						@price = RicPricing.price_model.find_by_id(params[:id])
						if @price.nil? || @price.price_list_id != @price_list.id
							redirect_to request.referrer, alert: I18n.t("activerecord.errors.models.#{RicPricing.price_model.model_name.i18n_key}.not_found")
						end
					end

					def price_params
						params.require(:price).permit(RicPricing.price_model.permitted_columns)
					end

				end
			end
		end
	end
end
