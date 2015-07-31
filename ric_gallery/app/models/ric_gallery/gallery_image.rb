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
	class GalleryImage < ActiveRecord::Base
		include RicGallery::Concerns::Models::GalleryImage
	end
end
