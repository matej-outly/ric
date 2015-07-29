# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Title component
# *
# * Author: Matěj Outlý
# * Date  : 29. 7. 2015
# *
# *****************************************************************************

class RicWebsite::TitleComponent < RugController::Component

	def control
		send_broadcast(:title)
	end

	#
	# Receive all answers to broadcast
	#
	def callback_title(results)
		
		# Remove blank subtitles
		@subtitles = results.map { |subtitle| (subtitle.blank? ? nil : subtitle) }.compact

		# Uniq subtitles
		@subtitles = @subtitles.insert(0, config(:main_title)).uniq
		@subtitles.delete_at(0)
		
	end

end