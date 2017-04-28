# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Confirmations
# *
# * Author: Matěj Outlý
# * Date  : 12. 11. 2015
# *
# *****************************************************************************

module RicAuth
	class ConfirmationsController < Devise::ConfirmationsController
		include RicAuth.devise_paths_concern

		if !RicAuth.layout.blank?
			layout RicAuth.layout.to_s
		end
	end
end