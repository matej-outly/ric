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

				included do
					before_action :authenticate_user!
				end

				def create
					override = RicAuth.override_model.new(override_params)
					session[RicAuth.override_model.session_key] = override.save_to_session
					flash[:notice] = I18n.t("activerecord.notices.models.ric_auth/override.create", user: override.user.name_formatted) if override.user
					redirect_to request.referrer
				end

			protected

				def override_params
					params.require(:override).permit(RicAuth.override_model.permitted_columns)
				end

			end
		end
	end
end
