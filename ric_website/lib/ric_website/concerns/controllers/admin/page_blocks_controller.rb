# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Page blocks
# *
# * Author: Matěj Outlý
# * Date  : 16. 7. 2015
# *
# *****************************************************************************

module RicWebsite
	module Concerns
		module Controllers
			module Admin
				module PageBlocksController extend ActiveSupport::Concern

					#
					# 'included do' causes the included code to be evaluated in the
					# context where it is included, rather than being executed in 
					# the module's context.
					#
					included do
					
						#
						# Set page_block before some actions
						#
						before_action :set_page_block, only: [:show, :edit, :update, :move, :destroy]

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
						@page_block = RicWebsite.page_block_model.new
						if params[:page_id]
							@page_block.page_id = params[:page_id] 
						else
							redirect_to main_app.root_path, alert: I18n.t("activerecord.errors.models.#{RicWebsite.page_block_model.model_name.i18n_key}.attributes.page_id.blank")
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
						@page_block = RicWebsite.page_block_model.new(page_block_params)
						if @page_block.save
							respond_to do |format|
								format.html { redirect_to page_block_path(@page_block), notice: I18n.t("activerecord.notices.models.#{RicWebsite.page_block_model.model_name.i18n_key}.create") }
								format.json { render json: @page_block.id }
							end
						else
							respond_to do |format|
								format.html { render "new" }
								format.json { render json: @page_block.errors }
							end
						end
					end

					#
					# Update action
					#
					def update
						if @page_block.update(page_block_params)
							respond_to do |format|
								format.html { redirect_to page_block_path(@page_block), notice: I18n.t("activerecord.notices.models.#{RicWebsite.page_block_model.model_name.i18n_key}.update") }
								format.json { render json: @page_block.id }
							end
						else
							respond_to do |format|
								format.html { render "edit" }
								format.json { render json: @page_block.errors }
							end
						end
					end

					#
					# Move action
					#
					def move
						if RicWebsite.page_block_model.move(params[:id], params[:relation], params[:destination_id])
							respond_to do |format|
								format.html { redirect_to ric_website_admin.page_path(@page_block.page_id), notice: I18n.t("activerecord.notices.models.#{RicWebsite.page_block_model.model_name.i18n_key}.move") }
								format.json { render json: true }
							end
						else
							respond_to do |format|
								format.html { redirect_to main_app.root_path, alert: I18n.t("activerecord.errors.models.#{RicWebsite.page_block_model.model_name.i18n_key}.move") }
								format.json { render json: false }
							end
						end
					end

					#
					# Destroy action
					#
					def destroy
						@page_block.destroy
						respond_to do |format|
							format.html { redirect_to page_path(@page_block.page_id), notice: I18n.t("activerecord.notices.models.#{RicWebsite.page_block_model.model_name.i18n_key}.destroy") }
							format.json { render json: @page_block.id }
						end
					end

				protected

					def set_page_block
						@page_block = RicWebsite.page_block_model.find_by_id(params[:id])
						if @page_block.nil?
							redirect_to main_app.root_path, alert: I18n.t("activerecord.errors.models.#{RicWebsite.page_block_model.model_name.i18n_key}.not_found")
						end
					end

					# 
					# Never trust parameters from the scary internet, only allow the white list through.
					#
					def page_block_params
						params.require(:page_block).permit(
							:title, 
							:content, 
							:page_id,
							:key
						)
					end

				end
			end
		end
	end
end
