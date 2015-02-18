# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Sent newsletter
# *
# * Author: Matěj Outlý
# * Date  : 16. 2. 2015
# *
# *****************************************************************************

module RicNewsletter
	class SentNewsletter < ActiveRecord::Base
		include RicNewsletter::Concerns::Models::SentNewsletter
		
	end
end