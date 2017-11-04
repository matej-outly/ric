# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Sequence
# *
# * Author: Matěj Outlý
# * Date  : 3. 11. 2017
# *
# *****************************************************************************

module RicNumbering
	module Concerns
		module Models
			module Sequence extend ActiveSupport::Concern

				included do
					
					# *********************************************************
					# Structure
					# *********************************************************

					belongs_to :owner, polymorphic: true
					belongs_to :scope, polymorphic: true

					# *********************************************************
					# Validators
					# *********************************************************
					
					validates_presence_of :ref, :current

					# *********************************************************
					# Default value
					# *********************************************************

					before_validation do
						self.current = 1 if self.current.nil?
					end

					# *********************************************************
					# Ref
					# *********************************************************

					if RicNumbering.sequence_refs
						enum_column :ref, RicNumbering.sequence_refs
					end

				end

				#
				# Return current number and increase it for next call
				#
				def increase

					# Result value
					result = self.current

					# Increase
					self.current += 1

					# Save
					self.save

					return result
				end
			
			end
		end
	end
end