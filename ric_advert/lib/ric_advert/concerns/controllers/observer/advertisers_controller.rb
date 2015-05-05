# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Advertisers
# *
# * Author: Matěj Outlý
# * Date  : 16. 12. 2014
# *
# *****************************************************************************

module RicAdvert
	module Concerns
		module Controllers
			module Observer
				module AdvertisersController extend ActiveSupport::Concern

					#
					# 'included do' causes the included code to be evaluated in the
					# context where it is included, rather than being executed in 
					# the module's context.
					#
					included do

						#
						# Set advertiser before some actions
						#
						before_action :set_advertiser, only: [:show]
		
					end

					#
					# Index action
					#
					def index
						@advertisers = RicAdvert.advertiser_model.all.order(name: :asc)
					end

					#
					# Show action
					#
					def show
						@today = Date.today
					end

				protected

					def set_advertiser
						@advertiser = RicAdvert.advertiser_model.find_by_id(params[:id])
						if @advertiser.nil?
							redirect_to advertisers_path, error: I18n.t("activerecord.errors.models.advertiser.not_found")
						end
					end

				end
			end
		end
	end
end
