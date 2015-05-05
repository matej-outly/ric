# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Account
# *
# * Author: Matěj Outlý
# * Date  : 5. 5. 2015
# *
# *****************************************************************************

require_dependency "ric_account/application_controller"

module RicAccount
	class AccountController < ApplicationController
		include RicAccount::Concerns::Controllers::AccountController
	end
end