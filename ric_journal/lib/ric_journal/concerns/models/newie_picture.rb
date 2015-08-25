# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Newie picture
# *
# * Author: Matěj Outlý
# * Date  : 28. 8. 2015
# *
# *****************************************************************************

module RicJournal
	module Concerns
		module Models
			module NewiePicture extend ActiveSupport::Concern

				#
				# 'included do' causes the included code to be evaluated in the
				# context where it is included, rather than being executed in 
				# the module's context.
				#
				included do
					
					# *********************************************************************
					# Structure
					# *********************************************************************
					
					#
					# Relation to newies
					#
					belongs_to :newie, class_name: RicJournal.newie_model.to_s

					#
					# Ordering
					#
					enable_ordering

					# *************************************************************************
					# Attachments
					# *************************************************************************

					#
					# Picture
					#
					has_attached_file :picture, :styles => { :thumb => config(:picture_crop, :thumb), :full => config(:picture_crop, :full) }
					validates_attachment_content_type :picture, :content_type => /\Aimage\/.*\Z/

					# *************************************************************************
					# Validators
					# *************************************************************************

					#
					# Newie must be present
					#
					validates_presence_of :newie_id

				end

			end
		end
	end
end