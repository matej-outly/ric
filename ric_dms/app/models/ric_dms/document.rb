# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Document model
# *
# * Author:
# * Date  : 19. 2. 2017
# *
# *****************************************************************************

module RicDms
	class Document < ActiveRecord::Base
		include RicDms::Concerns::Models::Document
	end
end