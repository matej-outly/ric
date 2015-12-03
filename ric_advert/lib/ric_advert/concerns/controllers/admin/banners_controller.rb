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
			module Admin
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
						before_action :set_banner, only: [:show, :edit, :update, :destroy]

					end

					#
					# Index action
					#
					def index
						today = Date.today
						@valid_banners = RicAdvert.banner_model.valid(today).order(advertiser_id: :asc, name: :asc)
						@sofar_invalid_banners = RicAdvert.banner_model.sofar_invalid(today).order(advertiser_id: :asc, name: :asc)
						@already_invalid_banners = RicAdvert.banner_model.already_invalid(today).order(advertiser_id: :asc, name: :asc)
					end

					#
					# Show action
					#
					def show
					end

					#
					# New action
					#
					def new
						@banner = RicAdvert.banner_model.new(banner_new_params)
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
						@banner = RicAdvert.banner_model.new(banner_params)
						if @banner.save
							respond_to do |format|
								format.html { redirect_to banner_path(@banner), notice: I18n.t("activerecord.notices.models.#{RicAdvert.banner_model.model_name.i18n_key}.create") }
								format.json { render json: @banner.id }
							end
						else
							respond_to do |format|
								format.html { render "new" }
								format.json { render json: @banner.errors }
							end
						end
					end

					#
					# Update action
					#
					def update
						if @banner.update(banner_params)
							respond_to do |format|
								format.html { redirect_to banner_path(@banner), notice: I18n.t("activerecord.notices.models.#{RicAdvert.banner_model.model_name.i18n_key}.update") }
								format.json { render json: @banner.id }
							end
						else
							respond_to do |format|
								format.html { render "edit" }
								format.json { render json: @banner.errors }
							end
						end
					end

					#
					# Destroy action
					#
					def destroy
						@banner.destroy
						respond_to do |format|
							format.html { redirect_to banners_path, notice: I18n.t("activerecord.notices.models.#{RicAdvert.banner_model.model_name.i18n_key}.destroy") }
							format.json { render json: @banner.id }
						end
					end

				protected

					def set_banner
						@banner = RicAdvert.banner_model.find_by_id(params[:id])
						if @banner.nil?
							redirect_to banners_path, alert: I18n.t("activerecord.errors.models.#{RicAdvert.banner_model.model_name.i18n_key}.not_found")
						end
					end

					# 
					# Never trust parameters from the scary internet, only allow the white list through.
					#
					def banner_params
						params.require(:banner).permit(:advertiser_id, :name, :url, :kind, :file, :valid_from, :valid_to, :priority)
					end

					# 
					# Never trust parameters from the scary internet, only allow the white list through.
					#
					def banner_new_params
						params.permit(:advertiser_id)
					end

				end
			end
		end
	end
end
