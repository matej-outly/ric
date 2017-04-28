# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Paths definition
# *
# * Author: Matěj Outlý
# * Date  : 19. 2. 2017
# *
# *****************************************************************************

module RicAuth
	module Concerns
		module DevisePaths extend ActiveSupport::Concern

			def after_sign_in_path_for(resource)
				stored_location_for(:user) || current_root_path
			end

			def after_sign_out_path_for(resource)
				main_app.root_path
			end

			def after_sign_up_path_for(resource)
				after_sign_in_path_for(resource)
			end

			def after_inactive_sign_up_path_for(resource)
				main_app.root_path
			end

			def after_inactive_sign_in_path_for(resource)
				if request.path.starts_with?("/admin") # Ugly but whatever
					ric_auth_admin.new_session_path
				else
					ric_auth.new_session_path
				end
			end

		end
	end
end