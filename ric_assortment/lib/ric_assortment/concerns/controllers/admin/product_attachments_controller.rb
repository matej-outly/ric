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
						@product_attachments = RicAssortment.product_attachment_model.all.order(position: :asc).page(params[:page]).per(50)
					end

					#
					# Search action
					#
					def search
						@product_attachments = RicAssortment.product_attachment_model.search(params[:q]).order(title: :asc)
						respond_to do |format|
							format.html { render "index" }
							format.json { render json: @product_attachments.to_json }
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
						save_referrer
						@product_attachment = RicAssortment.product_attachment_model.new
						@product_attachment.product_ids = [ params[:product_id] ] if params[:product_id]
					end

					#
					# Edit action
					#
					def edit
						save_referrer
					end

					#
					# Create action
					#
					def create
						@product_attachment = RicAssortment.product_attachment_model.new(product_attachment_params)
						if @product_attachment.save
							respond_to do |format|
								format.html { redirect_to load_referrer, notice: I18n.t("activerecord.notices.models.#{RicAssortment.product_attachment_model.model_name.i18n_key}.create") }
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
							respond_to do |format|
								format.html { redirect_to load_referrer, notice: I18n.t("activerecord.notices.models.#{RicAssortment.product_attachment_model.model_name.i18n_key}.update") }
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
							format.html { redirect_to request.referrer, notice: I18n.t("activerecord.notices.models.#{RicAssortment.product_attachment_model.model_name.i18n_key}.destroy") }
							format.json { render json: @product_attachment.id }
						end
					end

				protected

					# *********************************************************
					# Model setters
					# *********************************************************

					def set_product_attachment
						@product_attachment = RicAssortment.product_attachment_model.find_by_id(params[:id])
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
					def product_attachment_params
						result = params.require(:product_attachment).permit(:title, :file, :product_ids)
						result[:product_ids] = result[:product_ids].split(",") if !result[:product_ids].blank?
						return result
					end

				end
			end
		end
	end
end
