# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Overrides
# *
# * Author: Matěj Outlý
# * Date  : 24. 3. 2017
# *
# *****************************************************************************

module RicAuth
	module Concerns
		module Controllers
			module OverridesController extend ActiveSupport::Concern

				#
				# 'included do' causes the included code to be evaluated in the
				# context where it is included, rather than being executed in 
				# the module's context.
				#
				included do
					
					before_action :authenticate_user!

				end

				def role
					role = params[:role]
					if current_user && current_user.roles.include?(role)
						session[session_key] = {} if !session[session_key]
						session[session_key]["role"] = role
						session[session_key]["role_changed"] = true
						redirect_to request.referrer, notice: I18n.t("activerecord.notices.ric_auth.override_role_set", role: current_user.class.role_obj(role).label.downcase_first)
					else 
						redirect_to request.referrer, alert: I18n.t("activerecord.errors.ric_auth.override_role_not_set")
					end
				end

				def user
					# TODO
				end

			protected

				def session_key
					"auth_overrides"
				end

			end
		end
	end
end
