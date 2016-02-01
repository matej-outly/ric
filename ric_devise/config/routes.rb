# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Routes
# *
# * Author: Matěj Outlý
# * Date  : 9. 6. 2015
# *
# *****************************************************************************

RicDevise::Engine.routes.draw do

	root "root#index"

	#
	# RIC Devise
	#
	#devise_for :users, controllers: { sessions: "ric_devise/sessions", passwords: "ric_devise/passwords" }
	
	devise_for :users, class_name: RicDevise.user_model.to_s, module: :devise

end
