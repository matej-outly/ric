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
			module Observer
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
						before_action :set_banner, only: [:show]
						
					end

					#
					# Show action
					#
					def show
						@banner_statistics = @banner.banner_statistics.order(ip: :asc).page(params[:page])
					end

				protected

					def set_banner
						@banner = RicAdvert.banner_model.find_by_id(params[:id])
						if @banner.nil?
							redirect_to banners_path, alert: I18n.t("activerecord.errors.models.banner.not_found")
						end
					end

				end
			end
		end
	end
end