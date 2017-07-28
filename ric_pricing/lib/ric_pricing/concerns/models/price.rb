# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Price
# *
# * Author: Matěj Outlý
# * Date  : 29. 3. 2017
# *
# *****************************************************************************

module RicPricing
	module Concerns
		module Models
			module Price extend ActiveSupport::Concern

				included do
					
					# *********************************************************
					# Structure
					# *********************************************************

					belongs_to :price_list, class_name: RicPricing.price_list_model.to_s

					# *********************************************************
					# Ordering
					# *********************************************************

					enable_ordering

					# *********************************************************
					# Operator
					# *********************************************************

					enum_column :operator, [:equal, :from, :to], default: :equal

				end

				module ClassMethods

					# *********************************************************
					# Columns
					# *********************************************************

					def permitted_columns
						result = [
							:price_list_id,
							:description,
							:price,
							:currency,
							:amount,
							:operator
						]
						return result
					end

				end

			end
		end
	end
end