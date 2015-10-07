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

module RicWebsite
	module Helpers
		module SettingHelper

			def self.setting_get(key)

				# Find model
				setting = RicWebsite.setting_model.find_by_key(key)

				# Return value
				if setting
					return setting.value
				else
					return nil
				end
			end

			def setting_get(key)
				return SettingHelper.setting_get(key)
			end

			def self.setting_set(key, value)

				# Find model
				setting = RicWebsite.setting_model.find_by_key(key)

				# Save value
				if setting
					setting.value = value
					return setting.save
				else
					return false
				end
			end

			def setting_set(key, value)
				return SettingHelper.setting_get(key, value)
			end

		end
	end
end
