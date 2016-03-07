# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Pages
# *
# * Author: Matěj Outlý
# * Date  : 16. 7. 2015
# *
# *****************************************************************************

module RicWebsite
	module Concerns
		module Controllers
			module Admin
				module PagesController extend ActiveSupport::Concern

					#
					# 'included do' causes the included code to be evaluated in the
					# context where it is included, rather than being executed in 
					# the module's context.
					#
					included do
					
						#
						# Set page before some actions
						#
						before_action :set_page, only: [:show, :edit, :update, :move_up, :move_down, :destroy]

					end

					#
					# Index action
					#
					def index
						@pages = RicWebsite.page_model.all.order(lft: :asc)
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
						@page = RicWebsite.page_model.new
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
						@page = RicWebsite.page_model.new(page_params)
						@page.save # Page ID must be known
						@page.check_model_consistency
						@page.generate_url
						if @page.save
							respond_to do |format|
								format.html { redirect_to page_path(@page), notice: I18n.t("activerecord.notices.models.#{RicWebsite.page_model.model_name.i18n_key}.create") }
								format.json { render json: @page.id }
							end
						else
							respond_to do |format|
								format.html { render "new" }
								format.json { render json: @page.errors }
							end
						end
					end

					#
					# Update action
					#
					def update
						@page.assign_attributes(page_params)
						@page.check_model_consistency
						@page.generate_url
						if @page.save
							respond_to do |format|
								format.html { redirect_to page_path(@page), notice: I18n.t("activerecord.notices.models.#{RicWebsite.page_model.model_name.i18n_key}.update") }
								format.json { render json: @page.id }
							end
						else
							respond_to do |format|
								format.html { render "edit" }
								format.json { render json: @page.errors }
							end
						end
					end

					def move_up
						@page.move_left
						respond_to do |format|
							format.html { redirect_to pages_path, notice: I18n.t("activerecord.notices.models.#{RicWebsite.page_model.model_name.i18n_key}.move") }
							format.json { render json: @page.id }
						end
					end

					def move_down
						@page.move_right
						respond_to do |format|
							format.html { redirect_to pages_path, notice: I18n.t("activerecord.notices.models.#{RicWebsite.page_model.model_name.i18n_key}.move") }
							format.json { render json: @page.id }
						end
					end

					#
					# Destroy action
					#
					def destroy
						@page.destroy
						respond_to do |format|
							format.html { redirect_to pages_path, notice: I18n.t("activerecord.notices.models.#{RicWebsite.page_model.model_name.i18n_key}.destroy") }
							format.json { render json: @page.id }
						end
					end

				protected

					def set_page
						@page = RicWebsite.page_model.find_by_id(params[:id])
						if @page.nil?
							redirect_to pages_path, alert: I18n.t("activerecord.errors.models.#{RicWebsite.page_model.model_name.i18n_key}.not_found")
						end
					end

					# 
					# Never trust parameters from the scary internet, only allow the white list through.
					#
					def page_params
						permitted_params = []
						RicWebsite.page_model.parts.each do |part|
							permitted_params.concat(RicWebsite.page_model.method("#{part.to_s}_part_columns".to_sym).call)
						end
						params.require(:page).permit(permitted_params)
					end

				end
			end
		end
	end
end
