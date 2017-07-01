# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Privilege
# *
# * Author: Matěj Outlý
# * Date  : 1. 7. 2017
# *
# *****************************************************************************

module RicAcl
	class Privilege < ActiveRecord::Base
		include RicAcl::Concerns::Models::Privilege
	end
end
