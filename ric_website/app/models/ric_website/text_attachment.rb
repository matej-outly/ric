# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Text attachment
# *
# * Author: Matěj Outlý
# * Date  : 15. 7. 2015
# *
# *****************************************************************************

module RicWebsite
	class TextAttachment < ActiveRecord::Base
		include RicWebsite::Concerns::Models::TextAttachment
	end
end
