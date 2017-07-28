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
		module ApplicationPaths extend ActiveSupport::Concern

			def after_unauthenticated_path_for(resource)
				store_location_for(:user, request.path)
				if defined?(RicAuthAdmin) && request.path.starts_with?("/admin") # Ugly but whatever
					ric_auth_admin.new_session_path
				else
					ric_auth.new_session_path
				end
			end

			def current_root_path
				main_app.root_path
			end

		end
	end
end