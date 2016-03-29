# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Reference
# *
# * Author: Matěj Outlý
# * Date  : 8. 3. 2015
# *
# *****************************************************************************

module RicPartnership
	class Reference < ActiveRecord::Base
		include RicPartnership::Concerns::Models::Reference
	end
end
