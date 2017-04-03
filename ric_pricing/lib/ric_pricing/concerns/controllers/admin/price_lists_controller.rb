# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Price lists
# *
# * Author: Matěj Outlý
# * Date  : 29. 3. 2017
# *
# *****************************************************************************

module RicPricing
	module Concerns
		module Controllers
			module Admin
				module PriceListsController extend ActiveSupport::Concern

					#
					# 'included do' causes the included code to be evaluated in the
					# context where it is included, rather than being executed in 
					# the module's context.
					#
					included do
						
						before_action :save_referrer, only: [:new, :edit]
						before_action :set_price_list, only: [:show, :edit, :update, :move, :destroy]

					end

					def index
						@price_lists = RicPricing.price_list_model.all.order(position: :asc).page(params[:page]).per(50)
					end

					def show
						respond_to do |format|
							format.html { render "show" }
							format.json { render json: @price_list.to_json }
						end
					end

					def new
						@price_list = RicPricing.price_list_model.new
					end

					def edit
					end

					def create
						@price_list = RicPricing.price_list_model.new(price_list_params)
						if @price_list.save
							respond_to do |format|
								format.html { redirect_to load_referrer, notice: I18n.t("activerecord.notices.models.#{RicPricing.price_list_model.model_name.i18n_key}.create") }
								format.json { render json: @price_list.id }
							end
						else
							respond_to do |format|
								format.html { render "new" }
								format.json { render json: @price_list.errors }
							end
						end
					end

					def update
						if @price_list.update(price_list_params)
							respond_to do |format|
								format.html { redirect_to load_referrer, notice: I18n.t("activerecord.notices.models.#{RicPricing.price_list_model.model_name.i18n_key}.update") }
								format.json { render json: @price_list.id }
							end
						else
							respond_to do |format|
								format.html { render "edit" }
								format.json { render json: @price_list.errors }
							end
						end
					end

					def move
						if RicPricing.price_list_model.move(params[:id], params[:relation], params[:destination_id])
							respond_to do |format|
								format.html { redirect_to request.referrer, notice: I18n.t("activerecord.notices.models.#{RicPricing.price_list_model.model_name.i18n_key}.move") }
								format.json { render json: true }
							end
						else
							respond_to do |format|
								format.html { redirect_to request.referrer, alert: I18n.t("activerecord.errors.models.#{RicPricing.price_list_model.model_name.i18n_key}.move") }
								format.json { render json: false }
							end
						end
					end
					
					def destroy
						@price_list.destroy
						respond_to do |format|
							format.html { redirect_to ric_pricing_admin.price_lists_path, notice: I18n.t("activerecord.notices.models.#{RicPricing.price_list_model.model_name.i18n_key}.destroy") }
							format.json { render json: @price_list.id }
						end
					end

				protected

					def set_price_list
						@price_list = RicPricing.price_list_model.find_by_id(params[:id])
						if @price_list.nil?
							redirect_to request.referrer, status: :see_other, alert: I18n.t("activerecord.errors.models.#{RicPricing.price_list_model.model_name.i18n_key}.not_found")
						end
					end

					def price_list_params
						params.require(:price_list).permit(RicPricing.price_list_model.permitted_columns)
					end

				end
			end
		end
	end
end
