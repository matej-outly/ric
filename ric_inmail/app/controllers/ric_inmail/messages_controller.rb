# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Messages
# *
# * Author: Matěj Outlý
# * Date  : 19. 2. 2017
# *
# *****************************************************************************

require_dependency "ric_inmail/application_controller"

module RicInmail
	class MessagesController < ApplicationController
		include RicInmail::Concerns::Controllers::MessagesController
	end
end