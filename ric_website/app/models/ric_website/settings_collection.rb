# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Settings collection
# *
# * Author: Matěj Outlý
# * Date  : 7. 10. 2015
# *
# *****************************************************************************

module RicWebsite
	class SettingsCollection < ActiveRecord::Base
		include RicWebsite::Concerns::Models::SettingsCollection

		#
		# Define available settings
		#
		#setting "setting1", :string, "category1"
		#setting "setting2", :integer, "category1"
		#setting "setting3", :enum, "category3", values: ["value1", "value2", "value3"]

	end
end

