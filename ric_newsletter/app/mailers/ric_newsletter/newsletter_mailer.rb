# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Newsletter mailer
# *
# * Author: Matěj Outlý
# * Date  : 17. 2. 2015
# *
# *****************************************************************************

module RicNewsletter
	class NewsletterMailer < ::ApplicationMailer
		include RicNewsletter::Concerns::Mailers::NewsletterMailer

	end
end
