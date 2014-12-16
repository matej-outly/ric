# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Banner statistic
# *
# * Author: Matěj Outlý
# * Date  : 10. 12. 2014
# *
# *****************************************************************************

module RicAdvert
	module Concerns
		module Models
			module BannerStatistic extend ActiveSupport::Concern
				
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
					# Relation to banners
					#
					belongs_to :banner, class_name: RicAdvert.banner_model.to_s

				end

			end
		end
	end
end