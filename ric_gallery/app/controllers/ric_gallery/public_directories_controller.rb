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

require_dependency "ric_gallery/admin_controller"

module RicGallery
	class PublicDirectoriesController < PublicController
		include RicGallery::Concerns::Controllers::Public::DirectoriesController
	end
end