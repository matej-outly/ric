# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Menus
# *
# * Author: Matěj Outlý
# * Date  : 16. 7. 2015
# *
# *****************************************************************************

module RicWebsite
	module Concerns
		module Controllers
			module Admin
				module MenusController extend ActiveSupport::Concern

					#
					# 'included do' causes the included code to be evaluated in the
					# context where it is included, rather than being executed in 
					# the module's context.
					#
					included do
					
						#
						# Set menu before some actions
						#
						before_action :set_menu, only: [:show, :edit, :update, :destroy]

					end

					#
					# Index action
					#
					def index
						@menus = RicWebsite.menu_model.all.order(created_at: :asc)
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
						@menu = RicWebsite.menu_model.new
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
						@menu = RicWebsite.menu_model.new(menu_params)
						if @menu.save
							redirect_to menu_path(@menu), notice: I18n.t("activerecord.notices.models.#{RicWebsite.menu_model.model_name.i18n_key}.create")
						else
							render "new"
						end
					end

					#
					# Update action
					#
					def update
						if @menu.update(menu_params)
							redirect_to menu_path(@menu), notice: I18n.t("activerecord.notices.models.#{RicWebsite.menu_model.model_name.i18n_key}.update")
						else
							render "edit"
						end
					end

					#
					# Destroy action
					#
					def destroy
						@menu.destroy
						redirect_to menus_path, notice: I18n.t("activerecord.notices.models.#{RicWebsite.menu_model.model_name.i18n_key}.destroy")
					end

				protected

					def set_menu
						@menu = RicWebsite.menu_model.find_by_id(params[:id])
						if @menu.nil?
							redirect_to menus_path, alert: I18n.t("activerecord.errors.models.#{RicWebsite.menu_model.model_name.i18n_key}.not_found")
						end
					end

					# 
					# Never trust parameters from the scary internet, only allow the white list through.
					#
					def menu_params
						params.require(:menu).permit(:key, :name)
					end

				end
			end
		end
	end
end
