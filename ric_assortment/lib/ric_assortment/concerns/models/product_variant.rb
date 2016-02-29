# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Product variant
# *
# * Author: Matěj Outlý
# * Date  : 26. 11. 2015
# *
# *****************************************************************************

module RicAssortment
	module Concerns
		module Models
			module ProductVariant extend ActiveSupport::Concern

				#
				# 'included do' causes the included code to be evaluated in the
				# conproduct where it is included, rather than being executed in 
				# the module's conproduct.
				#
				included do
					
					# *********************************************************
					# Structure
					# *********************************************************

					#
					# Relation to sub-products
					#
					has_and_belongs_to_many :sub_products, class_name: RicAssortment.product_model.to_s

					#
					# Relation to parent products
					#
					belongs_to :product, class_name: RicAssortment.product_model.to_s

					# *********************************************************
					# Ordering
					# *********************************************************

					enable_ordering
					
					# *********************************************************
					# Validators
					# *********************************************************

					#
					# Product must be present
					#
					validates_presence_of :product_id

					# *********************************************************
					# Operator
					# *********************************************************

					enum_column :operator, [:xor]

				end

				# *************************************************************
				# Duplicate
				# *************************************************************

				def duplicate
					
					# Base duplication
					new_record = self.dup

					ActiveRecord::Base.transaction do

						# Base save
						new_record.save

						# Sub products
						new_record.sub_products = self.sub_products

					end

					return new_record
				end

			end
		end
	end
end