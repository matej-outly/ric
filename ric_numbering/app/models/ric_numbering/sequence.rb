# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Sequence
# *
# * Author: Matěj Outlý
# * Date  : 3. 11. 2017
# *
# *****************************************************************************

module RicNumbering
	class Sequence < ActiveRecord::Base
		include RicNumbering::Concerns::Models::Sequence
	end
end
