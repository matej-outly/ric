# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Page menu relations
# *
# * Author: Matěj Outlý
# * Date  : 16. 7. 2015
# *
# *****************************************************************************

module RicWebsite
	module Concerns
		module Controllers
			module Admin
				module PageMenuRelationsController extend ActiveSupport::Concern

					#
					# 'included do' causes the included code to be evaluated in the
					# context where it is included, rather than being executed in 
					# the module's context.
					#
					included do
					
						#
						# Set page before some actions
						#
						before_action :set_page, only: [:edit, :update, :destroy]

						#
						# Set menu before some actions
						#
						before_action :set_menu, only: [:destroy]

					end

					#
					# Edit action
					#
					def edit
						@menus = RicWebsite.menu_model.all.order(created_at: :asc)
					end

					#
					# Update action
					#
					def update
						@page.menu_ids = menu_ids_from_params
						redirect_to page_path(@page), notice: I18n.t("activerecord.notices.models.#{RicWebsite.page_model.model_name.i18n_key}.bind_menu")
					end

					#
					# Destroy action
					#
					def destroy
						@page.menus.delete(@menu)
						redirect_to page_path(@page), notice: I18n.t("activerecord.notices.models.#{RicWebsite.page_model.model_name.i18n_key}.unbind_menu")
					end

				protected

					def set_page
						@page = RicWebsite.page_model.find_by_id(params[:id])
						if @page.nil?
							redirect_to pages_path, alert: I18n.t("activerecord.errors.models.#{RicWebsite.page_model.model_name.i18n_key}.not_found")
						end
					end

					def set_menu
						@menu = RicWebsite.menu_model.find_by_id(params[:menu_id])
						if @menu.nil?
							redirect_to pages_path, alert: I18n.t("activerecord.errors.models.#{RicWebsite.menu_model.model_name.i18n_key}.not_found")
						end
					end

					# 
					# Never trust parameters from the scary internet, only allow the white list through.
					#
					def menu_ids_from_params
						if params[:page] && params[:page][:menus] && params[:page][:menus].is_a?(Hash)
							return params[:page][:menus].keys
						else
							return []
						end
					end

				end
			end
		end
	end
end
