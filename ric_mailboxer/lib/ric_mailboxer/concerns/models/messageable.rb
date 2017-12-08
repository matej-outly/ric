# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Messageable model
# *
# * Author: Matěj Outlý
# * Date  : 8. 12. 2017
# *
# *****************************************************************************

module RicMailboxer
	module Concerns
		module Models
			module Messageable extend ActiveSupport::Concern

				included do

					acts_as_messageable
					
				end

			end
		end
	end
end