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
						@product_attachment.product_ids = [ params[:product_id] ] if params[:product_id]
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
							@product_attachment.product_ids = product_ids_from_params
							respond_to do |format|
								format.html { redirect_to product_attachment_path(@product_attachment), notice: I18n.t("activerecord.notices.models.#{RicAssortment.product_attachment_model.model_name.i18n_key}.create") }
								format.json { render json: @product_attachment.id }
							end
						else
							respond_to do |format|
								format.html { render "new" }
								format.json { render json: @product_attachment.errors }
							end
						end
					end

					#
					# Update action
					#
					def update
						if @product_attachment.update(product_attachment_params)
							@product_attachment.product_ids = product_ids_from_params
							respond_to do |format|
								format.html { redirect_to product_attachment_path(@product_attachment), notice: I18n.t("activerecord.notices.models.#{RicAssortment.product_attachment_model.model_name.i18n_key}.update") }
								format.json { render json: @product_attachment.id }
							end
						else
							respond_to do |format|
								format.html { render "edit" }
								format.json { render json: @product_attachment.errors }
							end
						end
					end

					#
					# Destroy action
					#
					def destroy
						@product_attachment.destroy
						respond_to do |format|
							format.html { redirect_to product_attachments_path, notice: I18n.t("activerecord.notices.models.#{RicAssortment.product_attachment_model.model_name.i18n_key}.destroy") }
							format.json { render json: @product_attachment.id }
						end
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

					# 
					# Never trust parameters from the scary internet, only allow the white list through.
					#
					def product_ids_from_params
						params.require(:product_attachment).permit(:product_ids)
						if params[:product_attachment] && params[:product_attachment][:product_ids]
							return params[:product_attachment][:product_ids].split(" ")
						else
							return []
						end
					end

				end
			end
		end
	end
end
