# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Product teasers
# *
# * Author: Matěj Outlý
# * Date  : 12. 8. 2015
# *
# *****************************************************************************

module RicAssortment
	module Concerns
		module Controllers
			module Admin
				module ProductTeasersController extend ActiveSupport::Concern

					included do
						
						before_action :save_referrer, only: [:new, :edit]
						before_action :set_product_teaser, only: [:show, :edit, :update, :unbind_product, :destroy]
						before_action :set_product, only: [:unbind_product]

					end

					def index
						@product_teasers = RicAssortment.product_teaser_model.all.order(id: :asc)
					end

					def search
						@product_teasers = RicAssortment.product_teaser_model.search(params[:q]).order(id: :asc)
						respond_to do |format|
							format.html { render "index" }
							format.json { render json: @product_teasers.to_json }
						end
					end

					def show
					end

					def new
						@product_teaser = RicAssortment.product_teaser_model.new
					end

					def edit
					end

					def create
						@product_teaser = RicAssortment.product_teaser_model.new(product_teaser_params)
						if @product_teaser.save
							redirect_to load_referrer, notice: I18n.t("activerecord.notices.models.#{RicAssortment.product_teaser_model.model_name.i18n_key}.create")
						else
							render "new"
						end
					end

					def update
						if @product_teaser.update(product_teaser_params)
							redirect_to load_referrer, notice: I18n.t("activerecord.notices.models.#{RicAssortment.product_teaser_model.model_name.i18n_key}.update")
						else
							render "edit"
						end
					end

					def unbind_product
						@product_teaser.products.delete(@product)
						redirect_to request.referrer, notice: I18n.t("activerecord.notices.models.#{RicAssortment.product_teaser_model.model_name.i18n_key}.product_unbind")
					end

					def destroy
						@product_teaser.destroy
						redirect_to product_teasers_path, notice: I18n.t("activerecord.notices.models.#{RicAssortment.product_teaser_model.model_name.i18n_key}.destroy")
					end

				protected

					def set_product_teaser
						@product_teaser = RicAssortment.product_teaser_model.find_by_id(params[:id])
						if @product_teaser.nil?
							redirect_to request.referrer, status: :see_other, alert: I18n.t("activerecord.errors.models.#{RicAssortment.product_teaser_model.model_name.i18n_key}.not_found")
						end
					end

					def set_product
						@product = RicAssortment.product_model.find_by_id(params[:product_id])
						if @product.nil?
							redirect_to request.referrer, status: :see_other, alert: I18n.t("activerecord.errors.models.#{RicAssortment.product_model.model_name.i18n_key}.not_found")
						end
					end

					def product_teaser_params
						result = params.require(:product_teaser).permit(RicAssortment.product_teaser_model.permitted_columns)
						result[:product_ids] = result[:product_ids].split(",") if !result[:product_ids].blank?
						return result
					end

				end
			end
		end
	end
end
