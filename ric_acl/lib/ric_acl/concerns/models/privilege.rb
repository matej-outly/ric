# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Privilege
# *
# * Author: Matěj Outlý
# * Date  : 1. 7. 2017
# *
# *****************************************************************************

module RicAcl
	module Concerns
		module Models
			module Privilege extend ActiveSupport::Concern

				included do

					belongs_to :owner, polymorphic: true

				end

				module ClassMethods

					

				end

			end
		end
	end
end