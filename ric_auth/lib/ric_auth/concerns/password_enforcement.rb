# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Overrides
# *
# * Author: Matěj Outlý
# * Date  : 19. 2. 2017
# *
# *****************************************************************************

module RicAuth
	module Concerns
		module PasswordEnforcement extend ActiveSupport::Concern
			
			included do

				before_action :check_password_enforcement

			end

			def disable_password_enforcement
				@disable_password_enforcement = true
			end

			def check_password_enforcement
				if @disable_password_enforcement != true && !current_user.nil?
					if current_user.password_changed_at.nil? || (!current_user.password_forced_at.nil? && current_user.password_changed_at < current_user.password_forced_at)
						store_location_for(:user, request.path)
						redirect_to ric_auth.edit_profile_password_path, alert: RicAuth.user_model.human_error_message(:password_enforced)
					end
				end
			end

		end
	end
end