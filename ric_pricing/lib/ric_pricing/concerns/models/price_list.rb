# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Price list
# *
# * Author: Matěj Outlý
# * Date  : 29. 3. 2017
# *
# *****************************************************************************

module RicPricing
	module Concerns
		module Models
			module PriceList extend ActiveSupport::Concern

				included do
					
					# *********************************************************
					# Structure
					# *********************************************************

					belongs_to :subject, polymorphic: true
					has_many :prices, class_name: RicPricing.price_model.to_s, dependent: :destroy

					# *********************************************************
					# Ordering
					# *********************************************************

					enable_ordering

				end

				module ClassMethods

					# *********************************************************
					# Columns
					# *********************************************************

					def permitted_columns
						result = [
							:name,
							:subject_id,
							:subject_type
						]
						return result
					end

				end

			end
		end
	end
end