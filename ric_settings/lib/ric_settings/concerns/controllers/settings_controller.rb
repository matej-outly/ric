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
			module SettingsController extend ActiveSupport::Concern

				included do
				
					before_action :set_settings_collection, only: [:show, :edit, :update]

				end

				def show
				end

				def edit
				end

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

				def settings_collection_params
					params.require(:settings_collection).permit(RicSettings.settings_collection_model.permitted_columns)
				end

			end
		end
	end
end
