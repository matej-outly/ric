# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Settings
# *
# * Author: Matěj Outlý
# * Date  : 13. 5. 2015
# *
# *****************************************************************************

module RicSettings
	module Concerns
		module Controllers
			module Admin
				module SettingsController extend ActiveSupport::Concern

					#
					# 'included do' causes the included code to be evaluated in the
					# context where it is included, rather than being executed in 
					# the module's context.
					#
					included do
					
						#
						# Set text before some actions
						#
						before_action :set_settings_collection, only: [:show, :edit, :update]

					end

					#
					# Show action
					#
					def show
					end

					#
					# Edit action
					#
					def edit
					end

					#
					# Update action
					#
					def update
						@settings_collection.assign_attributes(settings_collection_params)
						if @settings_collection.save
							redirect_to settings_path, notice: I18n.t("activerecord.notices.models.#{RicSettings.setting_model.model_name.i18n_key}.update")
						else
							format.html { render "edit" }
						end						
					end

				protected

					def set_settings_collection
						@settings_collection = RicSettings.settings_collection_model.new
					end

					# 
					# Never trust parameters from the scary internet, only allow the white list through.
					#
					def settings_collection_params
						params.require(:settings_collection).permit(RicSettings.settings_collection_model.permitted_columns)
					end

				end
			end
		end
	end
end
