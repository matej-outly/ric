# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Image
# *
# * Author: Matěj Outlý
# * Date  : 31. 7. 2015
# *
# *****************************************************************************

module RicGallery
	class Image < ActiveRecord::Base
		include RicGallery::Concerns::Models::Image
	end
end
