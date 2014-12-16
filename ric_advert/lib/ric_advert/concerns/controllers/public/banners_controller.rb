# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Banners
# *
# * Author: Matěj Outlý
# * Date  : 16. 12. 2014
# *
# *****************************************************************************

module RicAdvert
	module Concerns
		module Controllers
			module Public
				module BannersController extend ActiveSupport::Concern

					#
					# 'included do' causes the included code to be evaluated in the
					# context where it is included, rather than being executed in 
					# the module's context.
					#
					included do

						#
						# Set banner before some actions
						#
						before_action :set_banner, only: [:click]
		
					end

					#
					# Request for banner impression
					#
					def get
						banner = RicAdvert.banner_model.random(params[:kind], Date.today)
						if banner
							banner.impressed(request.remote_ip)
						end
						render :json => banner.to_json(methods: [:image_url])
					end

					#
					# Banner clicked
					#
					def click
						if @banner
							result = @banner.clicked(request.remote_ip)
						else
							result = false
						end
						render :json => result
					end

				protected

					def set_banner
						@banner = RicAdvert.banner_model.find_by_id(params[:id])
					end

				end
			end
		end
	end
end