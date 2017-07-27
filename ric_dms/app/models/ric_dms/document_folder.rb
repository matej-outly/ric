# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Document folder model
# *
# * Author: Jaroslav Mlejnek
# * Date  : 19. 2. 2017
# *
# *****************************************************************************

module RicDms
	class DocumentFolder < ActiveRecord::Base
		include RicDms::Concerns::Models::DocumentFolder
	end
end