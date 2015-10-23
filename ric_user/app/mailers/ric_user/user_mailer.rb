# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * User mailer
# *
# * Author: Matěj Outlý
# * Date  : 9. 6. 2015
# *
# *****************************************************************************

module RicUser
	class UserMailer < ::ApplicationMailer
		include RicUser::Concerns::Mailers::UserMailer
	end
end
