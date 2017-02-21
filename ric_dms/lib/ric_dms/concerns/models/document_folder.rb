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

				included do

					# *************************************************************************
					# Structure
					# *************************************************************************

					enable_hierarchical_ordering

					has_many :documents, class_name: RicDms.document_model.to_s,  dependent: :destroy

				end

				module ClassMethods

					# *************************************************************************
					# Columns
					# *************************************************************************

					#
					# Get all columns permitted for editation
					#
					def permitted_columns
						[
							:name,
							:parent_id
						]
					end

				end

			end
		end
	end
end