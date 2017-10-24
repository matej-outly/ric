# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * People selectors
# *
# * Author: Matěj Outlý
# * Date  : 11. 4. 2017
# *
# *****************************************************************************

require_dependency "ric_person/application_controller"

module RicPerson
	class PeopleSelectorsController < ApplicationController
		include RicPerson::Concerns::Controllers::PeopleSelectorsController
	end
end