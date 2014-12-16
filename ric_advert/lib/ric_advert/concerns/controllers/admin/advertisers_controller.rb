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
			module Admin
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
						before_action :set_advertiser, only: [:show, :edit, :update, :destroy]

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

					#
					# New action
					#
					def new
						@advertiser = RicAdvert.advertiser_model.new
					end

					#
					# Edit action
					#
					def edit
					end

					#
					# Create action
					#
					def create
						@advertiser = RicAdvert.advertiser_model.new(advertiser_params)
						if @advertiser.save
							redirect_to admin_advertiser_path(@advertiser), notice: I18n.t("activerecord.notices.models.#{RicAdvert.advertiser_model.model_name.i18n_key}.create")
						else
							render "new"
						end
					end

					#
					# Update action
					#
					def update
						if @advertiser.update(advertiser_params)
							redirect_to admin_advertiser_path(@advertiser), notice: I18n.t("activerecord.notices.models.#{RicAdvert.advertiser_model.model_name.i18n_key}.update")
						else
							render "edit"
						end
					end

					#
					# Destroy action
					#
					def destroy
						@advertiser.destroy
						redirect_to admin_advertisers_path, notice: I18n.t("activerecord.notices.models.#{RicAdvert.advertiser_model.model_name.i18n_key}.destroy")
					end

				protected

					def set_advertiser
						@advertiser = RicAdvert.advertiser_model.find_by_id(params[:id])
						if @advertiser.nil?
							redirect_to admin_advertisers_path, error: I18n.t("activerecord.errors.models.#{RicAdvert.advertiser_model.model_name.i18n_key}.not_found")
						end
					end

					# 
					# Never trust parameters from the scary internet, only allow the white list through.
					#
					def advertiser_params
						params.require(:advertiser).permit(:name)
					end

				end
			end
		end
	end
end
