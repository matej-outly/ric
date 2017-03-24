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
		module Overrides extend ActiveSupport::Concern
			
			included do	
				before_action :override_role_if_possible
			end

			def override_role_if_possible
				if current_user
					if session["auth_overrides"] && session["auth_overrides"]["role"]
						if current_user.roles.include?(session["auth_overrides"]["role"])
							current_user.current_role = session["auth_overrides"]["role"]
							role_changed = session["auth_overrides"]["role_changed"]
							session["auth_overrides"]["role_changed"] = false
							if role_changed
								redirect_to current_root_path
							end
						else
							session["auth_overrides"].delete("role")
							session["auth_overrides"]["role_changed"] = false
						end
					end
				end
			end

		end
	end
end