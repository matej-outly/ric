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

					#
					# 'included do' causes the included code to be evaluated in the
					# conproduct where it is included, rather than being executed in 
					# the module's conproduct.
					#
					included do
					
						#
						# Set product before some actions
						#
						before_action :set_product_teaser, only: [:show, :edit, :update, :unbind_product, :destroy]

						#
						# Set product before some actions
						#
						before_action :set_product, only: [:unbind_product]

					end

					#
					# Index action
					#
					def index
						@product_teasers = RicAssortment.product_teaser_model.all.order(id: :asc)
					end

					#
					# Search action
					#
					def search
						@product_teasers = RicAssortment.product_teaser_model.search(params[:q]).order(id: :asc)
						respond_to do |format|
							format.html { render "index" }
							format.json { render json: @product_teasers.to_json }
						end
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
						@product_teaser = RicAssortment.product_teaser_model.new
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
						@product_teaser = RicAssortment.product_teaser_model.new(product_teaser_params)
						if @product_teaser.save
							redirect_to product_teaser_path(@product_teaser), notice: I18n.t("activerecord.notices.models.#{RicAssortment.product_teaser_model.model_name.i18n_key}.create")
						else
							render "new"
						end
					end

					#
					# Update action
					#
					def update
						if @product_teaser.update(product_teaser_params)
							redirect_to product_teaser_path(@product_teaser), notice: I18n.t("activerecord.notices.models.#{RicAssortment.product_teaser_model.model_name.i18n_key}.update")
						else
							render "edit"
						end
					end

					#
					# Unbind product action
					#
					def unbind_product
						@product_teaser.products.delete(@product)
						redirect_to product_teaser_path(@product_teaser), notice: I18n.t("activerecord.notices.models.#{RicAssortment.product_teaser_model.model_name.i18n_key}.product_unbind")
					end

					#
					# Destroy action
					#
					def destroy
						@product_teaser.destroy
						redirect_to product_teasers_path, notice: I18n.t("activerecord.notices.models.#{RicAssortment.product_teaser_model.model_name.i18n_key}.destroy")
					end

				protected

					def set_product_teaser
						@product_teaser = RicAssortment.product_teaser_model.find_by_id(params[:id])
						if @product_teaser.nil?
							redirect_to main_app.root_path, alert: I18n.t("activerecord.errors.models.#{RicAssortment.product_teaser_model.model_name.i18n_key}.not_found")
						end
					end

					def set_product
						@product = RicAssortment.product_model.find_by_id(params[:product_id])
						if @product.nil?
							redirect_to main_app.root_path, alert: I18n.t("activerecord.errors.models.#{RicAssortment.product_model.model_name.i18n_key}.not_found")
						end
					end

					# 
					# Never trust parameters from the scary internet, only allow the white list through.
					#
					def product_teaser_params
						result = params.require(:product_teaser).permit(:name, :key, :product_ids)
						result[:product_ids] = result[:product_ids].split(",") if !result[:product_ids].blank?
						return result
					end

				end
			end
		end
	end
end
