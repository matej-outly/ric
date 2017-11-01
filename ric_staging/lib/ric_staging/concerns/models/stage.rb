# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Stage
# *
# * Author: Matěj Outlý
# * Date  : 31. 10. 2017
# *
# *****************************************************************************

module RicStaging
	module Concerns
		module Models
			module Stage extend ActiveSupport::Concern

				included do
				
					# *********************************************************
					# Structure
					# *********************************************************

					belongs_to :subject, polymorphic: true

					# *********************************************************
					# Validators
					# *********************************************************
					
					# *********************************************************
					# Stage
					# *********************************************************

					# 
					# :done - least dominant
					# :developed - most dominant
					#
					state_column :stage, [:done, :none, :obsolete, :developed], default: :none

				end

				module ClassMethods

					# *********************************************************
					# Columns
					# *********************************************************
					
					def permitted_columns
						[
							:stage,
						]
					end

				end
			
			end
		end
	end
end