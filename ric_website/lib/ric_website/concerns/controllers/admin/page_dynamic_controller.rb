# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Page dynamic
# *
# * Author: Matěj Outlý
# * Date  : 16. 7. 2015
# *
# *****************************************************************************

module RicWebsite
	module Concerns
		module Controllers
			module Admin
				module PageDynamicController extend ActiveSupport::Concern

					#
					# 'included do' causes the included code to be evaluated in the
					# context where it is included, rather than being executed in 
					# the module's context.
					#
					included do
					
					end

					#
					# Available models action
					#
					def available_models
						@page = RicWebsite.page_model.new
						if params[:nature]
							@page.nature = params[:nature]
						end
						result = []
						@page.available_models.each do |model|
							result << { title: model.title, id: model.id } # TODO configurable title
						end
						render json: result
					end

				protected

				end
			end
		end
	end
end
