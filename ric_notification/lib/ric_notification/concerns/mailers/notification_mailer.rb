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

				def notify(notification, receiver)
					
					# Sender
					@sender = RicNotification.mailer_sender
					if @sender.nil?
						raise "Please specify sender."
					end

					# Other view data
					@notification = notification
					@receiver = receiver
					
					# Subject
					subject = !@notification.subject.blank? ? @notification.subject : I18n.t("activerecord.mailers.ric_notification.notification.notify.subject", url: main_app.root_url)
					
					# Attachment
					if !notification.attachment.blank?
						attachments[File.basename(notification.attachment)] = File.read(notification.attachment)
					end

					# Mail
					mail(from: @sender, to: receiver.email, subject: subject)
				end

			end
		end
	end
end
