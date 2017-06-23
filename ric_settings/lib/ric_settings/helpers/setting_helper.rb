# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Setting helper
# *
# * Author: Matěj Outlý
# * Date  : 7. 10. 2015
# *
# *****************************************************************************

module RicSettings
	module Helpers
		module SettingHelper

			def self.setting_get(ref)

				# Find model
				setting = RicSettings.setting_model.find_by_ref(ref)

				# Return value
				if setting
					return setting.value
				else
					return nil
				end
			end

			def setting_get(ref)
				return SettingHelper.setting_get(ref)
			end

			def self.setting_set(ref, value)

				# Find model
				setting = RicSettings.setting_model.find_by_ref(ref)

				# Save value
				if setting
					setting.value = value
					return setting.save
				else
					return false
				end
			end

			def setting_set(ref, value)
				return SettingHelper.setting_get(ref, value)
			end

		end
	end
end
