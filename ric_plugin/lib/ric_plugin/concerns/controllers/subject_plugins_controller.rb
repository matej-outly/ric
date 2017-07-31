# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Subject plugins
# *
# * Author: Matěj Outlý
# * Date  : 1. 7. 2017
# *
# *****************************************************************************

module RicPlugin
	module Concerns
		module Controllers
			module SubjectPluginsController extend ActiveSupport::Concern

				included do
					before_action :set_subject
				end

				def show
				end

				def edit					
				end

				def update
				end

			protected

				def set_subject
					
				end

			end
		end
	end
end