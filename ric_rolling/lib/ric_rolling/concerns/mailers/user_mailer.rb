# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * User mailer
# *
# * Author: Matěj Outlý
# * Date  : 17. 3. 2015
# *
# *****************************************************************************

module RicRolling
	module Concerns
		module Mailers
			module UserMailer extend ActiveSupport::Concern

				#
				# Registration mail
				#
				def registration(user, tmp_password)
					@user = user
					@tmp_password = tmp_password
					@login_url = "http://" + Rails.application.config.action_mailer.default_url_options[:host].to_s + "/" + RicRolling.url_base.to_s + "/auth/login"
					mail(to: @user.email, subject: I18n.t("activerecord.mailers.ric_rolling/user.registration.subject"))
				end

			end
		end
	end
end