# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Document folder model
# *
# * Author:
# * Date  : 19. 2. 2017
# *
# *****************************************************************************

module RicDms
	module Concerns
		module Models
			module DocumentFolder extend ActiveSupport::Concern

				# *************************************************************************
				# Structure
				# *************************************************************************

				enable_hierarchical_ordering

				has_many :documents, dependent: :destroy

				# *************************************************************************
				# Columns
				# *************************************************************************

				#
				# Get all columns permitted for editation
				#
				def self.permitted_columns
					[
						:name,
						:parent_id
					]
				end

			end
		end
	end
end