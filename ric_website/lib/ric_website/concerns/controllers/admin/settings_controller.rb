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

module RicWebsite
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
						before_action :set_settings, only: [:show, :edit, :update]

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
						settings_params_to_save = settings_params
						@settings.each do |setting|
							if settings_params_to_save[setting.key]
								setting.value = settings_params_to_save[setting.key]
								setting.save
							end
						end
						redirect_to settings_path, notice: I18n.t("activerecord.notices.models.#{RicWebsite.setting_model.model_name.i18n_key}.update")
					end

				protected

					def set_settings
						@settings = RicWebsite.setting_model.all.order(position: :asc)
						@setting_categories = {}
						@settings.each do |setting|
							if setting.category
								if @setting_categories[setting.category].nil?
									@setting_categories[setting.category] = []
								end
								@setting_categories[setting.category] << setting
							end
						end
					end

					# 
					# Never trust parameters from the scary internet, only allow the white list through.
					#
					def settings_params
						permitted_params = @settings.map { |setting| setting.key.to_sym }
						params.require(:settings).permit(permitted_params)
					end

				end
			end
		end
	end
end
