# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Newsletter
# *
# * Author: Matěj Outlý
# * Date  : 16. 2. 2015
# *
# *****************************************************************************

module RicNewsletter
	class Newsletter < ActiveRecord::Base
		include RicNewsletter::Concerns::Models::Newsletter
		
	end
end