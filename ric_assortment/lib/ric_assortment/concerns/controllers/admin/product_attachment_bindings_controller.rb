# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Product attachment bindings
# *
# * Author: Matěj Outlý
# * Date  : 8. 7. 2015
# *
# *****************************************************************************

module RicAssortment
	module Concerns
		module Controllers
			module Admin
				module ProductAttachmentBindingsController extend ActiveSupport::Concern

					#
					# 'included do' causes the included code to be evaluated in the
					# conproduct where it is included, rather than being executed in 
					# the module's conproduct.
					#
					included do

						#
						# Set product before some actions
						#
						before_action :set_product, only: [:edit, :update, :destroy]

						#
						# Set product attachment before some actions
						#
						before_action :set_product_attachment, only: [:destroy]

					end

					#
					# New action
					#
					def edit
						@product_attachments = RicAssortment.product_attachment_model.all.order(position: :asc)
					end

					#
					# Create action
					#
					def update
						param_product_attachments = product_params[:product_attachments]
						@product.product_attachment_ids = ((!param_product_attachments.nil? && param_product_attachments.is_a?(Hash)) ? param_product_attachments.keys : [])
						redirect_to product_path(@product), notice: I18n.t("activerecord.notices.models.#{RicAssortment.product_model.model_name.i18n_key}.attachment_bind")
					end

					#
					# Destroy action
					#
					def destroy
						@product.product_attachments.delete(@product_attachment)
						redirect_to product_path(@product), notice: I18n.t("activerecord.notices.models.#{RicAssortment.product_model.model_name.i18n_key}.attachment_unbind")
					end

				protected

					def set_product
						@product = RicAssortment.product_model.find_by_id(params[:id])
						if @product.nil?
							redirect_to root_path, alert: I18n.t("activerecord.errors.models.#{RicAssortment.product_model.model_name.i18n_key}.not_found")
						end
					end

					def set_product_attachment
						@product_attachment = RicAssortment.product_attachment_model.find_by_id(params[:product_attachment_id])
						if @product_attachment.nil?
							redirect_to root_path, alert: I18n.t("activerecord.errors.models.#{RicAssortment.product_attachment_model.model_name.i18n_key}.not_found")
						end
					end

					# 
					# Never trust parameters from the scary internet, only allow the white list through.
					#
					def product_params
						if params[:product]
							params[:product].tap do |white_listed|
								white_listed[:product_attachments] = params[:product][:product_attachments] if params[:product] && params[:product][:product_attachments]
							end
						else
							return {}
						end
					end

				end
			end
		end
	end
end
