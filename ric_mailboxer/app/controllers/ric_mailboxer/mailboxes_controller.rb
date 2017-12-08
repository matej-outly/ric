# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Mailbox
# *
# * Author: Matěj Outlý
# * Date  : 8. 12. 2017
# *
# *****************************************************************************

require_dependency "ric_mailboxer/application_controller"

module RicMailboxer
	class MailboxesController < ApplicationController
		include RicMailboxer::Concerns::Controllers::MailboxesController
	end
end