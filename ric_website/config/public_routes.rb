# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Routes
# *
# * Author: Matěj Outlý
# * Date  : 13. 5. 2015
# *
# *****************************************************************************

RicWebsite::PublicEngine.routes.draw do

	# Texts
	resources :texts, only: [:show], controller: "public_texts" do
		member do
			get "inline_edit"
			post "inline_update"
		end
	end

end