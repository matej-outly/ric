# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Product pictures
# *
# * Author: Matěj Outlý
# * Date  : 29. 6. 2015
# *
# *****************************************************************************

module RicAssortment
	module Concerns
		module Controllers
			module Admin
				module ProductPicturesController extend ActiveSupport::Concern

					#
					# 'included do' causes the included code to be evaluated in the
					# conproduct where it is included, rather than being executed in 
					# the module's conproduct.
					#
					included do
					
						#
						# Set product before some actions
						#
						before_action :set_product
						before_action :set_product_picture, only: [:show, :edit, :update, :move, :destroy]

					end

					#
					# Show action
					#
					def show
						respond_to do |format|
							format.json { render json: @product_picture.to_json(methods: :picture_url) }
						end
					end

					#
					# New action
					#
					def new
						save_referrer
						@product_picture = RicAssortment.product_picture_model.new
						@product_picture.product_id = @product.id
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
						@product_picture = RicAssortment.product_picture_model.new(product_picture_params)
						@product_picture.product_id = @product.id
						if @product_picture.save
							respond_to do |format|
								format.html { redirect_to load_referrer, notice: I18n.t("activerecord.notices.models.#{RicAssortment.product_picture_model.model_name.i18n_key}.create") }
								format.json { render json: @product_picture.id }
							end
						else
							respond_to do |format|
								format.html { render "new" }
								format.json { render json: @product_picture.errors }
							end
						end
					end

					#
					# Update action
					#
					def update
						if @product_picture.update(product_picture_params)
							respond_to do |format|
								format.html { redirect_to load_referrer, notice: I18n.t("activerecord.notices.models.#{RicAssortment.product_picture_model.model_name.i18n_key}.update") }
								format.json { render json: @product_picture.id }
							end
						else
							respond_to do |format|
								format.html { render "edit" }
								format.json { render json: @product_picture.errors }
							end
						end
					end

					#
					# Move action
					#
					def move
						if RicAssortment.product_picture_model.move(params[:id], params[:relation], params[:destination_id])
							respond_to do |format|
								format.html { redirect_to request.referrer, notice: I18n.t("activerecord.notices.models.#{RicAssortment.product_picture_model.model_name.i18n_key}.move") }
								format.json { render json: @product_picture.id }
							end
						else
							respond_to do |format|
								format.html { redirect_to request.referrer, alert: I18n.t("activerecord.errors.models.#{RicAssortment.product_picture_model.model_name.i18n_key}.move") }
								format.json { render json: @product_picture.errors }
							end
						end
					end

					#
					# Destroy action
					#
					def destroy
						@product_picture.destroy
						respond_to do |format|
							format.html { redirect_to request.referrer, notice: I18n.t("activerecord.notices.models.#{RicAssortment.product_picture_model.model_name.i18n_key}.destroy") }
							format.json { render json: @product_picture.id }
						end
					end

				protected

					# *********************************************************
					# Model setters
					# *********************************************************

					def set_product
						@product = RicAssortment.product_model.find_by_id(params[:product_id])
						if @product.nil?
							redirect_to main_app.root_path, alert: I18n.t("activerecord.errors.models.#{RicAssortment.product_model.model_name.i18n_key}.not_found")
						end
					end

					def set_product_picture
						@product_picture = RicAssortment.product_picture_model.find_by_id(params[:id])
						if @product_picture.nil? || @product_picture.product_id != @product.id
							redirect_to main_app.root_path, alert: I18n.t("activerecord.errors.models.#{RicAssortment.product_picture_model.model_name.i18n_key}.not_found")
						end
					end

					# *********************************************************
					# Param filters
					# *********************************************************

					# 
					# Never trust parameters from the scary internet, only allow the white list through.
					#
					def product_picture_params
						params.require(:product_picture).permit(RicAssortment.product_picture_model.permitted_columns)
					end

				end
			end
		end
	end
end
