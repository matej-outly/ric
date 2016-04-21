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
				module PageNaturesController extend ActiveSupport::Concern

					#
					# 'included do' causes the included code to be evaluated in the
					# context where it is included, rather than being executed in 
					# the module's context.
					#
					included do
					
					end

					#
					# Show details about page nature
					#
					def show
						
						# Initiate page model
						@page = RicWebsite.page_model.new
						if params[:id]
							@page.nature = params[:id]
						end

						# Get available models
						available_models = []
						@page.available_models.each do |model|
							available_models << { title: model.title, id: model.id } # TODO configurable title
						end
						
						# Render result
						render json: {
							automatic_url: @page.automatic_url,
							available_models: available_models,
						}
						
					end

				protected

				end
			end
		end
	end
end
