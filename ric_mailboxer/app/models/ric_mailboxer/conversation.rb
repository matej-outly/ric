# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Conversation model
# *
# * Author: Jaroslav Mlejnek
# * Date  : 19. 2. 2017
# *
# *****************************************************************************

module RicMailboxer
	class Conversation
		include ActiveModel::Model
		include ActiveRecord::AttributeAssignment
		include RugRecord::Concerns::Messages
		include RicMailboxer::Concerns::Models::Conversation
	end
end