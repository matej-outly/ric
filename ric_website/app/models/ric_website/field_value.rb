# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Field/node value
# *
# * Author: Matěj Outlý
# * Date  : 19. 1. 2017
# *
# *****************************************************************************

module RicWebsite
	class FieldValue < ActiveRecord::Base
		include RicWebsite::Concerns::Models::FieldValue
	end
end
