# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Authorization
# *
# * Author:
# * Date  : 23. 2. 2017
# *
# *****************************************************************************

module RicDms
	module Concerns
		module Authorization extend ActiveSupport::Concern

			included do
				helper_method :can_load?
				helper_method :can_create?
				helper_method :can_update?
				helper_method :can_destroy?
			end

			def root_folder
				:all # All folders
			end

			def can_load?
				true
			end

			def can_create?
				true
			end

			def can_update?
				true
			end
			
			def can_destroy?
				true
			end

		end
	end
end