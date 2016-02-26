# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Description component
# *
# * Author: Matěj Outlý
# * Date  : 26. 2. 2016
# *
# *****************************************************************************

class RicWebsite::TitleComponent < RugController::Component

	def control
		send_broadcast(:description)
	end

	#
	# Receive all answers to broadcast
	#
	def callback_description(results)
		
		# Remove blank descriptions and select first
		@content = results.map { |description| (description.blank? ? nil : description) }.compact.first
		
	end

end