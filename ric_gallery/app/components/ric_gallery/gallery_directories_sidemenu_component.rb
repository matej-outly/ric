# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Sidemenu component
# *
# * Author: Matěj Outlý
# * Date  : 5. 8. 2015
# *
# *****************************************************************************

class RicGallery::GalleryDirectoriesSidemenuComponent < RugController::Component

	def control
		@gallery_directories = RicGallery.gallery_directory_model.all.order(lft: :asc)
	end

end