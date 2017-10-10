# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Attachment
# *
# * Author: Matěj Outlý
# * Date  : 9. 10. 2017
# *
# *****************************************************************************

module RicAttachment
	class Attachment < ActiveRecord::Base
		include RicAttachment::Concerns::Models::Attachment

		if !(defined?(RicUrl).nil?) && RicAttachment.enable_slugs == true
			include RicUrl::Concerns::Models::SlugGenerator
			include RicAttachment::Concerns::Models::SluggedAttachment
		end
		
	end
end
