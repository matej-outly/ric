# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Contact message mailer
# *
# * Author: Matěj Outlý
# * Date  : 19. 1. 2017
# *
# *****************************************************************************

module RicContact
	class ContactMessageMailer < ::ApplicationMailer
		include RicContact::Concerns::Mailers::ContactMessageMailer
	end
end
