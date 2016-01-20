# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Notification mailer
# *
# * Author: Matěj Outlý
# * Date  : 18. 6. 2015
# *
# *****************************************************************************

module RicNotification
	module Concerns
		module Mailers
			module NotificationMailer extend ActiveSupport::Concern

				#
				# New password
				#
				def new_password(notification, new_password)
					@notification = notification
					@password = new_password
					mail(from: RicNotification.mailer_sender, to: notification.email, subject: I18n.t("activerecord.mailers.ric_notification.notification.new_password.subject"))
				end

			end
		end
	end
end
