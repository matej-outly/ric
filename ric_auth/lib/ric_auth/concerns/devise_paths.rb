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
				if RicAuth.redirect_to_stored_location_after_sign_in == true
					stored_location_for(:user) || current_root_path
				else
					current_root_path
				end
			end

			def after_sign_out_path_for(resource)
				if RicAuth.redirect_to_stored_location_after_sign_out == true
					stored_location_for(:user) || main_app.root_path
				else
					main_app.root_path
				end
			end

			def after_sign_up_path_for(resource)
				if RicAuth.redirect_to_stored_location_after_sign_up == true
					stored_location_for(:user) || current_root_path
				else
					current_root_path
				end
			end

			def after_inactive_sign_up_path_for(resource)
				main_app.root_path
			end

			def after_inactive_sign_in_path_for(resource)
				if defined?(RicAuthAdmin) && request.path.starts_with?("/admin") # Ugly but whatever
					ric_auth_admin.new_session_path
				else
					ric_auth.new_session_path
				end
			end

			def after_sending_reset_password_instructions_path_for(resource)
				if defined?(RicAuthAdmin) && request.path.starts_with?("/admin") # Ugly but whatever
					ric_auth_admin.new_session_path
				else
					ric_auth.new_session_path
				end
			end

			def after_confirmation_path_for(resource_name, resource)
				main_app.root_path
			end

		end
	end
end