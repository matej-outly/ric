# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Picture
# *
# * Author: Matěj Outlý
# * Date  : 31. 7. 2015
# *
# *****************************************************************************

module RicGallery
	class GalleryPicture < ActiveRecord::Base
		include RicGallery::Concerns::Models::GalleryPicture
	end
end
