# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Conversations
# *
# * Author: Matěj Outlý
# * Date  : 8. 12. 2017
# *
# *****************************************************************************

require_dependency "ric_mailboxer/application_controller"

module RicMailboxer
	class ConversationsController < ApplicationController
		include RicMailboxer::Concerns::Controllers::ConversationsController
	end
end