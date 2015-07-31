# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Images
# *
# * Author: Matěj Outlý
# * Date  : 31. 7. 2015
# *
# *****************************************************************************

require_dependency "ric_gallery/admin_controller"

module RicGallery
	class AdminImagesController < AdminController
		include RicGallery::Concerns::Controllers::Admin::ImagesController
	end
end
