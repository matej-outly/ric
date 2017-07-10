# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Setting
# *
# * Author: Matěj Outlý
# * Date  : 7. 10. 2015
# *
# *****************************************************************************

module RicSettings
	module Concerns
		module Models
			module Setting extend ActiveSupport::Concern

				included do
					
					# *********************************************************
					# Ordering
					# *********************************************************

					enable_ordering
					
					# *********************************************************
					# Kind
					# *********************************************************

					enum_column :kind, [ :string, :integer, :enum, :integer_range, :double_range ]

					# *********************************************************
					# Validators
					# *********************************************************

					validates_presence_of :ref

				end

			end
		end
	end
end