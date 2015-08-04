# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Menu page relations
# *
# * Author: Matěj Outlý
# * Date  : 4. 8. 2015
# *
# *****************************************************************************

module RicWebsite
	module Concerns
		module Controllers
			module Admin
				module MenuPageRelationsController extend ActiveSupport::Concern

					#
					# 'included do' causes the included code to be evaluated in the
					# context where it is included, rather than being executed in 
					# the module's context.
					#
					included do
					
						#
						# Set menu before some actions
						#
						before_action :set_menu, only: [:edit, :update, :destroy]

						#
						# Set page before some actions
						#
						before_action :set_page, only: [:destroy]

					end

					#
					# Edit action
					#
					def edit
						@pages = RicWebsite.page_model.all.order(lft: :asc)
					end

					#
					# Update action
					#
					def update
						param_pages = menu_params[:pages]
						@menu.page_ids = ((!param_pages.nil? && param_pages.is_a?(Hash)) ? param_pages.keys : [])
						redirect_to menu_path(@menu), notice: I18n.t("activerecord.notices.models.#{RicWebsite.menu_model.model_name.i18n_key}.bind_page")
					end

					#
					# Destroy action
					#
					def destroy
						@menu.pages.delete(@page)
						redirect_to menu_path(@menu), notice: I18n.t("activerecord.notices.models.#{RicWebsite.menu_model.model_name.i18n_key}.unbind_page")
					end

				protected

					def set_menu
						@menu = RicWebsite.menu_model.find_by_id(params[:id])
						if @menu.nil?
							redirect_to menus_path, alert: I18n.t("activerecord.errors.models.#{RicWebsite.menu_model.model_name.i18n_key}.not_found")
						end
					end

					def set_page
						@page = RicWebsite.page_model.find_by_id(params[:page_id])
						if @page.nil?
							redirect_to menus_path, alert: I18n.t("activerecord.errors.models.#{RicWebsite.page_model.model_name.i18n_key}.not_found")
						end
					end

					# 
					# Never trust parameters from the scary internet, only allow the white list through.
					#
					def menu_params
						if params[:menu]
							params[:menu].tap do |white_listed|
								white_listed[:pages] = params[:menu][:pages] if params[:menu] && params[:menu][:pages]
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
