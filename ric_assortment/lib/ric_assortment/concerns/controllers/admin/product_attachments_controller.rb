# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Product attachments
# *
# * Author: Matěj Outlý
# * Date  : 8. 7. 2015
# *
# *****************************************************************************

module RicAssortment
	module Concerns
		module Controllers
			module Admin
				module ProductAttachmentsController extend ActiveSupport::Concern

					#
					# 'included do' causes the included code to be evaluated in the
					# conproduct where it is included, rather than being executed in 
					# the module's conproduct.
					#
					included do
					
						#
						# Set product before some actions
						#
						before_action :set_product_attachment, only: [:show, :edit, :update, :destroy]

					end

					#
					# Index action
					#
					def index
						@product_attachments = RicAssortment.product_attachment_model.all.order(position: :asc)
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
						@product_attachment = RicAssortment.product_attachment_model.new
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
						@product_attachment = RicAssortment.product_attachment_model.new(product_attachment_params)
						if @product_attachment.save
							redirect_to product_attachment_path(@product_attachment), notice: I18n.t("activerecord.notices.models.#{RicAssortment.product_attachment_model.model_name.i18n_key}.create")
						else
							render "new"
						end
					end

					#
					# Update action
					#
					def update
						if @product_attachment.update(product_attachment_params)
							redirect_to product_attachment_path(@product_attachment), notice: I18n.t("activerecord.notices.models.#{RicAssortment.product_attachment_model.model_name.i18n_key}.update")
						else
							render "edit"
						end
					end

					#
					# Destroy action
					#
					def destroy
						@product_attachment.destroy
						redirect_to product_attachments_path, notice: I18n.t("activerecord.notices.models.#{RicAssortment.product_attachment_model.model_name.i18n_key}.destroy")
					end

				protected

					def set_product_attachment
						@product_attachment = RicAssortment.product_attachment_model.find_by_id(params[:id])
						if @product_attachment.nil?
							redirect_to product_attachments_path, alert: I18n.t("activerecord.errors.models.#{RicAssortment.product_attachment_model.model_name.i18n_key}.not_found")
						end
					end

					# 
					# Never trust parameters from the scary internet, only allow the white list through.
					#
					def product_attachment_params
						params.require(:product_attachment).permit(:title, :file)
					end

				end
			end
		end
	end
end
