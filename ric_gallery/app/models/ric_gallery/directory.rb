# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Directory
# *
# * Author: Matěj Outlý
# * Date  : 30. 6. 2015
# *
# *****************************************************************************

module RicGallery
	class Directory < ActiveRecord::Base
		include RicGallery::Concerns::Models::Directory
	end
end
