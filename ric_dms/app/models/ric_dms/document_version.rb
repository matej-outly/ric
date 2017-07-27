# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Document version model
# *
# * Author: Jaroslav Mlejnek
# * Date  : 19. 2. 2017
# *
# *****************************************************************************

module RicDms
	class DocumentVersion < ActiveRecord::Base
		include RicDms::Concerns::Models::DocumentVersion
	end
end