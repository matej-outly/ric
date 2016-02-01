# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Abstract engine controller
# *
# * Author: Matěj Outlý
# * Date  : 10. 12. 2014
# *
# *****************************************************************************

module RicDevise
	class RootController < ApplicationController
		def index
			redirect_to main_app.root_path
		end
	end
end
