# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Notification mailer
# *
# * Author: Matěj Outlý
# * Date  : 9. 6. 2015
# *
# *****************************************************************************

module RicNotification
	class NotificationMailer < ::ApplicationMailer
		include RicNotification::Concerns::Mailers::NotificationMailer
	end
end
