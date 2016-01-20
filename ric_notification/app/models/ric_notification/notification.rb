# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Notification
# *
# * Author: Matěj Outlý
# * Date  : 9. 6. 2015
# *
# *****************************************************************************

module RicNotification
	class Notification < ActiveRecord::Base
		include RicNotification::Concerns::Models::Notification
	end
end
