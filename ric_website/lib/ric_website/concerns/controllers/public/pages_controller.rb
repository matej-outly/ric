# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Pages
# *
# * Author: Matěj Outlý
# * Date  : 13. 5. 2015
# *
# *****************************************************************************

module RicWebsite
	module Concerns
		module Controllers
			module Public
				module PagesController extend ActiveSupport::Concern

					#
					# 'included do' causes the included code to be evaluated in the
					# context where it is included, rather than being executed in 
					# the module's context.
					#
					included do
					
						#
						# Set page before somse actions
						#
						before_action :set_page, only: [:show]

						#
						# Implement broadcast which gathers all title messages
						#
						implement_broadcast :title

					end

					#
					# Show action
					#
					def show
					end

				protected

					#
					# Get title of current page model (if any)
					#
					def receive_title(arguments)
						if @page && @page.respond_to?(:title)
							return @page.title
						else
							return nil
						end
					end

					def set_page
						@page = RicWebsite.page_model.find_by_id(params[:id])
						if @page.nil?
							redirect_to main_app.root_path, alert: I18n.t("activerecord.errors.models.#{RicWebsite.page_model.model_name.i18n_key}.not_found")
						end
					end

				end
			end
		end
	end
end
