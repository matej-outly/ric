# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Product photo
# *
# * Author: Matěj Outlý
# * Date  : 29. 6. 2015
# *
# *****************************************************************************

module RicAssortment
	module Concerns
		module Models
			module ProductPhoto extend ActiveSupport::Concern

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
					# Relation to products
					#
					belongs_to :product, class_name: RicAssortment.product_model.to_s

					#
					# Ordering
					#
					enable_ordering
					
					# *************************************************************************
					# Attachments
					# *************************************************************************

					#
					# Photo
					#
					has_attached_file :image, :styles => { :thumb => "300x300>", :full => "1000x1000>" } # TODO configurable
					validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

					# *************************************************************************
					# Validators
					# *************************************************************************

					#
					# Product must be present
					#
					validates_presence_of :product_id

				end

			end
		end
	end
end