# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Routes
# *
# * Author: Matěj Outlý
# * Date  : 7. 3. 2015
# *
# *****************************************************************************

RicMagazine::AdminEngine.routes.draw do

	# Articles
	resources :articles, controller: "admin_articles"

end

RicMagazine::PublicEngine.routes.draw do

	# Articles
	resources :articles, controller: "public_articles", only: [:index, :show]

end