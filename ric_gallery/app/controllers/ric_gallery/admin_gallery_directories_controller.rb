# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Gallery Directories
# *
# * Author: Matěj Outlý
# * Date  : 30. 6. 2015
# *
# *****************************************************************************

require_dependency "ric_gallery/admin_controller"

module RicGallery
	class AdminGalleryDirectoriesController < AdminController
		include RicGallery::Concerns::Controllers::Admin::GalleryDirectoriesController
	end
end

