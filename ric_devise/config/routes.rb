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
	devise_for RicDevise.route_name.to_sym, class_name: RicDevise.user_model.to_s, module: :devise
end
