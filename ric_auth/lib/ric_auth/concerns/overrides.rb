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
				
				before_action :set_override
				before_action :override_role_if_possible
				before_action :redirect_if_override_changed

				# *************************************************************
				# Access to former current_user
				# *************************************************************

				helper_method :real_current_user

				# *************************************************************
				# Redefine current_user
				# *************************************************************

				define_method(:current_user) do
					if real_current_user && @override && !@override.user_id.blank? && @override.user.id != real_current_user.id
						if real_current_user.respond_to?(:can_override_user) && real_current_user.can_override_user == true
							return @override.user
						else
							session[RicAuth.override_model.session_key] = @override.clear_session
						end
					end
					return real_current_user
				end

			end

			def real_current_user
				@real_current_user ||= warden.authenticate(:scope => :user)
			end

			def set_override
				@override = RicAuth.override_model.new
				@override.load_from_session(session[RicAuth.override_model.session_key])
			end

			def override_role_if_possible
				if current_user && !@override.role_ref.blank?
					if current_user.respond_to?(:can_override_role) && current_user.can_override_role == true && current_user.roles.include?(@override.role_ref)
						current_user.current_role = @override.role_ref
					else
						session[RicAuth.override_model.session_key] = @override.clear_session
					end
				end
			end

			def redirect_if_override_changed
				if session[RicAuth.override_model.session_key]
					changed = session[RicAuth.override_model.session_key]["changed"]
					session[RicAuth.override_model.session_key]["changed"] = false
					if changed
						redirect_to current_root_path
					end
				end
			end

		end
	end
end