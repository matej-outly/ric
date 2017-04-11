# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Internal Message
# *
# * Author: Matěj Outlý
# * Date  : 19. 2. 2017
# *
# *****************************************************************************

module RicInmail
	class InMessage < ActiveRecord::Base
		include RicInmail::Concerns::Models::InMessage
		include RicUser::Concerns::Models::PeopleSelectable
	end
end
