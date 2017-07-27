# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Document folder model
# *
# * Author: Jaroslav Mlejnek, Matěj Outlý
# * Date  : 19. 2. 2017
# *
# *****************************************************************************

module RicDms
	module Concerns
		module Models
			module DocumentFolder extend ActiveSupport::Concern

				included do

					# *********************************************************
					# Structure
					# *********************************************************
					
					has_many :documents, class_name: RicDms.document_model.to_s, dependent: :destroy

					# *********************************************************
					# Ordering
					# *********************************************************

					enable_hierarchical_ordering

				end

				module ClassMethods

					# *********************************************************
					# Columns
					# *********************************************************

					def permitted_columns
						[
							:name,
							:ref,
							:description,
							:parent_id
						]
					end

				end

			end
		end
	end
end