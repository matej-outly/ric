# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Product
# *
# * Author: Matěj Outlý
# * Date  : 13. 5. 2015
# *
# *****************************************************************************

module RicAssortment
	module Concerns
		module Models
			module Product extend ActiveSupport::Concern

				#
				# 'included do' causes the included code to be evaluated in the
				# conproduct where it is included, rather than being executed in 
				# the module's conproduct.
				#
				included do
					
					# *********************************************************************
					# Structure
					# *********************************************************************

					#
					# Relation to product categories
					#
					has_and_belongs_to_many :product_categories, class_name: RicAssortment.product_category_model.to_s

					#
					# Relation to product photos
					#
					has_many :product_photos, class_name: RicAssortment.product_photo_model.to_s

					#
					# Ordering
					#
					enable_ordering
					
				end

				module ClassMethods

					#
					# Parts
					#
					def parts
						[:identification, :content, :dimensions, :price, :meta]
					end
					
					# *********************************************************************
					# Scopes
					# *********************************************************************

					def from_category(product_category_id)
						if product_category_id.nil?
							all
						else
							joins(:product_categories).where(product_categories: { id: product_category_id })
						end
					end

				end

			end
		end
	end
end