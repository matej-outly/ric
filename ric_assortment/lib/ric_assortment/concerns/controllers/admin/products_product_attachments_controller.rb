# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Products product attachments
# *
# * Author: Matěj Outlý
# * Date  : 8. 7. 2015
# *
# *****************************************************************************

module RicAssortment
	module Concerns
		module Controllers
			module Admin
				module ProductsProductAttachmentsController extend ActiveSupport::Concern

					#
					# 'included do' causes the included code to be evaluated in the
					# conproduct where it is included, rather than being executed in 
					# the module's conproduct.
					#
					included do

						before_action :set_product
						before_action :set_product_attachment, only: [:destroy]

					end

					#
					# Edit action
					#
					def edit
						save_referrer
					end

					#
					# Update action
					#
					def update
						if @product.update(product_params)
							redirect_to load_referrer, notice: I18n.t("activerecord.notices.models.#{RicAssortment.product_model.model_name.i18n_key}.update_attachments")
						else
							render "edit"
						end
					end

					#
					# Destroy action
					#
					def destroy
						@product.product_attachments.delete(@product_attachment)
						redirect_to request.referrer, notice: I18n.t("activerecord.notices.models.#{RicAssortment.product_model.model_name.i18n_key}.destroy_attachment")
					end

				protected


					# *********************************************************
					# Model setters
					# *********************************************************

					def set_product
						@product = RicAssortment.product_model.find_by_id(params[:id])
						if @product.nil?
							redirect_to main_app.root_path, alert: I18n.t("activerecord.errors.models.#{RicAssortment.product_model.model_name.i18n_key}.not_found")
						end
					end

					def set_product_attachment
						@product_attachment = RicAssortment.product_attachment_model.find_by_id(params[:product_attachment_id])
						if @product_attachment.nil?
							redirect_to main_app.root_path, alert: I18n.t("activerecord.errors.models.#{RicAssortment.product_attachment_model.model_name.i18n_key}.not_found")
						end
					end

					# *********************************************************
					# Param filters
					# *********************************************************

					# 
					# Never trust parameters from the scary internet, only allow the white list through.
					#
					def product_params
						result = params.require(:product).permit(:product_attachment_ids)
						result[:product_attachment_ids] = result[:product_attachment_ids].split(",") if !result[:product_attachment_ids].blank?
						return result
					end

				end
			end
		end
	end
end
