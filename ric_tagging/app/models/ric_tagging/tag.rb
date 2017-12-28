# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Tag
# *
# * Author: Matěj Outlý
# * Date  : 28. 12. 2017
# *
# *****************************************************************************

module RicTagging
	class Tag < ActiveRecord::Base
		include RicTagging::Concerns::Models::Tag
	end
end
