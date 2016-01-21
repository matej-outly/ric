# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Notification mailer
# *
# * Author: Matěj Outlý
# * Date  : 21. 1. 2016
# *
# *****************************************************************************

module RicNotification
	module Concerns
		module Mailers
			module NotificationMailer extend ActiveSupport::Concern

				#
				# New password
				#
				def notify(notification, receiver)
					@notification = notification
					@receiver = receiver
					mail(from: RicNotification.mailer_sender, to: receiver.email, subject: I18n.t("activerecord.mailers.ric_notification.notification.notify.subject", url: main_app.root_url))
				end

			end
		end
	end
end
