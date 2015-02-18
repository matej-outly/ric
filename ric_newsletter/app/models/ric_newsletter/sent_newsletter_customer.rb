# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Sent newsletter customer
# *
# * Author: Matěj Outlý
# * Date  : 17. 2. 2015
# *
# *****************************************************************************

module RicNewsletter
	class SentNewsletterCustomer < ActiveRecord::Base
		include RicNewsletter::Concerns::Models::SentNewsletterCustomer
		
	end
end