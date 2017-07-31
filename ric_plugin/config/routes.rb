# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Routes
# *
# * Author: Matěj Outlý
# * Date  : 1. 7. 2017
# *
# *****************************************************************************

RicPlugin::Engine.routes.draw do

	# Plugins
	resources :plugins, except: [:show]

	# Plugin subjects
	resources :subjects, only: [] do
		resource :plugin, only: [:show, :edit, :update], controller: "subject_plugins"
	end

end