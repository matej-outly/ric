# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Pictures ticker component
# *
# * Author: Matěj Outlý
# * Date  : 31. 8. 2015
# *
# *****************************************************************************

class RicGallery::GalleryPicturesTickerComponent < RugController::Component

	def control
		@gallery_pictures = RicGallery.gallery_picture_model.order("random()").limit(config(:limit))
	end

end