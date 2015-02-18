# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Newsletters
# *
# * Author: Matěj Outlý
# * Date  : 16. 2. 2015
# *
# *****************************************************************************

require_dependency "ric_newsletter/application_controller"

module RicNewsletter
	class Admin::NewslettersController < ApplicationController
		include RicNewsletter::Concerns::Controllers::Admin::NewslettersController
	end
end