# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Sessions
# *
# * Author: Matěj Outlý
# * Date  : 18. 3. 2015
# *
# *****************************************************************************

module RicRolling
	module Concerns
		module Controllers
			module SessionsController extend ActiveSupport::Concern

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
						redirect_to sign_in_path, error: I18n.t("activerecord.errors.models.ric_rolling/user.already_signed_in")
					end
					@user = RicRolling.user_model.new(user_params)
					if !RicRolling.user_model.sign_in(@user)
						render "new"
					else
						redirect_to main_app.root_path, notice: I18n.t("activerecord.notices.models.ric_rolling/user.sign_in")
					end
				end

				#
				# Destroy
				#
				def destroy
					if current_user.state == :hard
						RicRolling.user_model.sign_out
						RicRolling.user_model.authenticate
						redirect_to main_app.root_path, notice: I18n.t("activerecord.notices.models.ric_rolling/user.sign_out")
					else
						redirect_to main_app.root_path, error: I18n.t("activerecord.errors.models.ric_rolling/user.not_signed_in")
					end
				end

			protected

				def user_params
					params.require(:user).permit(:email, :password)			
				end

			end
		end
	end
end