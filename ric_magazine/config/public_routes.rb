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

RicMagazine::PublicEngine.routes.draw do

	# Articles
	resources :articles, controller: "public_articles", only: [:index, :show]

end