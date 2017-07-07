# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Routes
# *
# * Author: Matěj Outlý
# * Date  : 7. 7. 2017
# *
# *****************************************************************************

RicException::Engine.routes.draw do
	
	get "/404", :to => "exceptions#not_found"
	get "/422", :to => "exceptions#unacceptable"
	get "/500", :to => "exceptions#internal_error"

end