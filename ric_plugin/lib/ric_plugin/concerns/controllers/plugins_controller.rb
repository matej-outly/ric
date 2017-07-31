# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Plugins
# *
# * Author: Matěj Outlý
# * Date  : 1. 7. 2017
# *
# *****************************************************************************

module RicPlugin
	module Concerns
		module Controllers
			module PluginsController extend ActiveSupport::Concern

				included do
					before_action :set_plugin
				end

				def index
				end

				def new
				end

				def edit
				end

				def create
				end

				def update
				end

				def destroy
				end

			protected

				def set_plugin
					
				end

				def plugin_params
					
				end

			end
		end
	end
end