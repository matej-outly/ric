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
					@sender = RicNotification.mailer_sender
					if @sender.nil?
						raise "Please specify sender."
					end
					@notification = notification
					@receiver = receiver
					subject = !@notification.subject.blank? ? @notification.subject : I18n.t("activerecord.mailers.ric_notification.notification.notify.subject", url: main_app.root_url)
					mail(from: @sender, to: receiver.email, subject: subject)
				end

			end
		end
	end
end
