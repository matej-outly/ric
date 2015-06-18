# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Registrations
# *
# * Author: Matěj Outlý
# * Date  : 18. 3. 2015
# *
# *****************************************************************************

module RicRolling
	module Concerns
		module Controllers
			module RegistrationsController extend ActiveSupport::Concern

				#
				# New
				#
				def new
					@user = RicRolling.user_model.new
				end

				#
				# Create
				#
				def create
					if current_user.state == :hard
						redirect_to sign_up_path, alert: I18n.t("activerecord.errors.models.ric_rolling/user.already_signed_in")
					end
					@user = RicRolling.user_model.new(user_params)
					if !RicRolling.user_model.sign_up(@user)
						render "new"
					else
						redirect_to main_app.root_path, notice: I18n.t("activerecord.notices.models.ric_rolling/user.sign_up")
					end
				end

			protected

				def user_params
					params.require(:user).permit(:email)			
				end

			end
		end
	end
end
