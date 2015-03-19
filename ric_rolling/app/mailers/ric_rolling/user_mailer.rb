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
	class UserMailer < ::ApplicationMailer
		include RicRolling::Concerns::Mailers::UserMailer

	end
end

