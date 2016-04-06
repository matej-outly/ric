# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Contact person
# *
# * Author: Matěj Outlý
# * Date  : 6. 4. 2016
# *
# *****************************************************************************

module RicContact
	class ContactPerson < ActiveRecord::Base
		include RicContact::Concerns::Models::ContactPerson
	end
end
