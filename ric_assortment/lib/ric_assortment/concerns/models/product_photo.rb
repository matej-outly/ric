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
					
					# *********************************************************
					# Structure
					# *********************************************************

					#
					# Relation to products
					#
					belongs_to :product, class_name: RicAssortment.product_model.to_s

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
					if config(:picture_croppable) == true
						croppable_picture_column :picture, styles: { thumb: config(:picture_crop, :thumb), full: config(:picture_crop, :full) }
					else
						has_attached_file :picture, :styles => { thumb: config(:picture_crop, :thumb), full: config(:picture_crop, :full) }
						validates_attachment_content_type :picture, content_type: /\Aimage\/.*\Z/
					end
					
					# *********************************************************
					# Validators
					# *********************************************************

					#
					# Product must be present
					#
					validates_presence_of :product_id

				end

				# *************************************************************
				# Duplicate
				# *************************************************************

				def duplicate
					
					# Base duplication
					new_record = self.class.new(title: self.title, product_id: self.product_id) # Dup cannot be used because of attachment
					
					# Picture
					new_record.picture = self.picture
					
					# Save
					new_record.save

					return new_record
				end

			end
		end
	end
end