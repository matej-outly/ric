# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Product picture
# *
# * Author: Matěj Outlý
# * Date  : 29. 6. 2015
# *
# *****************************************************************************

module RicAssortment
	module Concerns
		module Models
			module ProductPicture extend ActiveSupport::Concern

				#
				# 'included do' causes the included code to be evaluated in the
				# conproduct where it is included, rather than being executed in 
				# the module's conproduct.
				#
				included do
					
					# *********************************************************
					# Structure
					# *********************************************************

					belongs_to :product, class_name: RicAssortment.product_model.to_s

					# *********************************************************
					# Validators
					# *********************************************************

					validates_presence_of :product_id

					# *********************************************************
					# Ordering
					# *********************************************************

					enable_ordering
					
					# *********************************************************
					# Picture
					# *********************************************************

					if config(:picture_croppable) == true
						croppable_picture_column :picture, styles: { thumb: config(:picture_crop, :thumb), full: config(:picture_crop, :full) }
					else
						has_attached_file :picture, :styles => { thumb: config(:picture_crop, :thumb), full: config(:picture_crop, :full) }
						validates_attachment_content_type :picture, content_type: /\Aimage\/.*\Z/
					end
					
				end

				module ClassMethods

					# *********************************************************
					# Columns
					# *********************************************************

					def permitted_columns
						[
							:title, 
							:picture, 
							:picture_crop_x, 
							:picture_crop_y, 
							:picture_crop_w, 
							:picture_crop_h,
							:picture_perform_cropping,
						]
					end

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