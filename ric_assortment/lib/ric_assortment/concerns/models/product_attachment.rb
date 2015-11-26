# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Product attachment
# *
# * Author: Matěj Outlý
# * Date  : 8. 7. 2015
# *
# *****************************************************************************

module RicAssortment
	module Concerns
		module Models
			module ProductAttachment extend ActiveSupport::Concern

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
					# Relation to products
					#
					has_and_belongs_to_many :products, class_name: RicAssortment.product_model.to_s

					#
					# Ordering
					#
					enable_ordering
					
					# *********************************************************
					# Attachments
					# *********************************************************

					#
					# Photo
					#
					has_attached_file :file
					validates_attachment :file, content_type: { content_type: /\Aapplication\/.*\Z/ }

				end

			end
		end
	end
end