# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Product panels
# *
# * Author: Matěj Outlý
# * Date  : 26. 11. 2015
# *
# *****************************************************************************

module RicAssortment
	module Concerns
		module Controllers
			module Admin
				module ProductPanelsController extend ActiveSupport::Concern

					#
					# 'included do' causes the included code to be evaluated in the
					# conproduct where it is included, rather than being executed in 
					# the module's conproduct.
					#
					included do
					
						#
						# Set product before some actions
						#
						before_action :set_product_panel, only: [:show, :edit, :update, :destroy]

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
						@product_panel = RicAssortment.product_panel_model.new
						if params[:product_id]
							@product_panel.product_id = params[:product_id] 
						else
							redirect_to root_path, alert: I18n.t("activerecord.errors.models.#{RicAssortment.product_panel_model.model_name.i18n_key}.attributes.product_id.blank")
						end
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
						@product_panel = RicAssortment.product_panel_model.new(product_panel_params)
						if @product_panel.save
							redirect_to product_panel_path(@product_panel), notice: I18n.t("activerecord.notices.models.#{RicAssortment.product_panel_model.model_name.i18n_key}.create")
						else
							render "new"
						end
					end

					#
					# Update action
					#
					def update
						if @product_panel.update(product_panel_params)
							redirect_to product_panel_path(@product_panel), notice: I18n.t("activerecord.notices.models.#{RicAssortment.product_panel_model.model_name.i18n_key}.update")
						else
							render "edit"
						end
					end

					#
					# Destroy action
					#
					def destroy
						@product_panel.destroy
						redirect_to product_path(@product_panel.product), notice: I18n.t("activerecord.notices.models.#{RicAssortment.product_panel_model.model_name.i18n_key}.destroy")
					end

				protected

					def set_product_panel
						@product_panel = RicAssortment.product_panel_model.find_by_id(params[:id])
						if @product_panel.nil?
							redirect_to root_path, alert: I18n.t("activerecord.errors.models.#{RicAssortment.product_panel_model.model_name.i18n_key}.not_found")
						end
					end

					# 
					# Never trust parameters from the scary internet, only allow the white list through.
					#
					def product_panel_params
						params.require(:product_panel).permit(:product_id, :name, :required, :operator)
					end

				end
			end
		end
	end
end
