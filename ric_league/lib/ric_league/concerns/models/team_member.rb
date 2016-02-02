# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Team member
# *
# * Author: Matěj Outlý
# * Date  : 27. 10. 2015
# *
# *****************************************************************************

module RicLeague
	module Concerns
		module Models
			module TeamMember extend ActiveSupport::Concern

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
					# Relation to teams
					#
					belongs_to :team, class_name: RicLeague.team_model.to_s

					#
					# Relation to league categories
					#
					belongs_to :league_category, class_name: RicLeague.league_category_model.to_s

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
					if config(:photo_croppable) == true
						croppable_picture_column :photo, styles: { thumb: config(:photo_crop, :thumb), full: config(:photo_crop, :full) }
					else
						has_attached_file :photo, :styles => { thumb: config(:photo_crop, :thumb), full: config(:photo_crop, :full) }
						validates_attachment_content_type :photo, content_type: /\Aimage\/.*\Z/
					end

					# *************************************************************************
					# Validators
					# *************************************************************************

					validates_presence_of :team_id

					# *************************************************************************
					# Enums
					# *************************************************************************

					enum_column :kind, ["player", "stuff"]

				end

			end
		end
	end
end