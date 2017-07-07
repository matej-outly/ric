# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Notification mailer
# *
# * Author: Matěj Outlý
# * Date  : 7. 7. 2017
# *
# *****************************************************************************

module RicException
	class ExceptionMailer < ::ApplicationMailer
		include RicException::Concerns::Mailers::ExceptionMailer
	end
end
