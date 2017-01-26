# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Contact message
# *
# * Author: Matěj Outlý
# * Date  : 30. 6. 2015
# *
# *****************************************************************************

if RicContact.save_contact_messages_to_db
	module RicContact
		class ContactMessage < ActiveRecord::Base
			include RicContact::Concerns::Models::ContactMessage
		end
	end
else
	module RicContact
		class ContactMessage
			include ActiveModel::Model
			include RugRecord::Concerns::Config
			include RicContact::Concerns::Models::ContactMessageTableless
		end
	end
end
