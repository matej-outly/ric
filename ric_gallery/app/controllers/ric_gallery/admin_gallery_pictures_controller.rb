# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Gallery Pictures
# *
# * Author: Matěj Outlý
# * Date  : 31. 7. 2015
# *
# *****************************************************************************

require_dependency "ric_gallery/admin_controller"

module RicGallery
	class AdminGalleryPicturesController < AdminController
		include RicGallery::Concerns::Controllers::Admin::GalleryPicturesController
	end
end
