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

module RicReference
	class Reference < ActiveRecord::Base
		include RicReference::Concerns::Models::Reference
	end
end
