# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Exceptions
# *
# * Author: Matěj Outlý
# * Date  : 7. 7. 2017
# *
# *****************************************************************************

module RicException
	class ExceptionsController < ::ApplicationController
		include RicException::Concerns::Controllers::ExceptionsController

		if !RicException.layout.blank?
			layout RicException.layout.to_s
		end
	end
end