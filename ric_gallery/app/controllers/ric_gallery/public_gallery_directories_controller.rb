# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Directories
# *
# * Author: Matěj Outlý
# * Date  : 30. 6. 2015
# *
# *****************************************************************************

require_dependency "ric_gallery/public_controller"

module RicGallery
	class PublicGalleryDirectoriesController < PublicController
		include RicGallery::Concerns::Controllers::Public::GalleryDirectoriesController
	end
end