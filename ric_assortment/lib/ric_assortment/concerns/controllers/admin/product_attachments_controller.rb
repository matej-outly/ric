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

					included do
					
						before_action :set_product_attachment, only: [:show, :edit, :update, :destroy]

					end

					def index
						@product_attachments = RicAssortment.product_attachment_model.all.order(position: :asc).page(params[:page]).per(50)
					end

					def search
						@product_attachments = RicAssortment.product_attachment_model.search(params[:q]).order(title: :asc)
						respond_to do |format|
							format.html { render "index" }
							format.json { render json: @product_attachments.to_json }
						end
					end

					def show
					end

					def new
						save_referrer
						@product_attachment = RicAssortment.product_attachment_model.new
						@product_attachment.product_ids = [ params[:product_id] ] if params[:product_id]
					end

					def edit
						save_referrer
					end

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
