# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Partners
# *
# * Author: Matěj Outlý
# * Date  : 8. 3. 2015
# *
# *****************************************************************************

module RicPartnership
	module Concerns
		module Controllers
			module PartnersController extend ActiveSupport::Concern

				included do
					
					before_action :save_referrer, only: [:new, :edit]
					before_action :set_partner, only: [:show, :edit, :update, :destroy]

				end

				def index
					@partners = RicPartnership.partner_model.all.order(position: :asc).page(params[:page]).per(50)
				end

				def show
					respond_to do |format|
						format.html { render "show" }
						format.json { render json: @partner.to_json }
					end
				end

				def new
					@partner = RicPartnership.partner_model.new
				end

				def edit
				end

				def create
					@partner = RicPartnership.partner_model.new(partner_params)
					if @partner.save
						respond_to do |format|
							format.html { redirect_to load_referrer, notice: I18n.t("activerecord.notices.models.#{RicPartnership.partner_model.model_name.i18n_key}.create") }
							format.json { render json: @partner.id }
						end
					else
						respond_to do |format|
							format.html { render "new" }
							format.json { render json: @partner.errors }
						end
					end
				end

				def update
					if @partner.update(partner_params)
						respond_to do |format|
							format.html { redirect_to load_referrer, notice: I18n.t("activerecord.notices.models.#{RicPartnership.partner_model.model_name.i18n_key}.update") }
							format.json { render json: @partner.id }
						end
					else
						respond_to do |format|
							format.html { render "edit" }
							format.json { render json: @partner.errors }
						end
					end
				end

				def move
					if RicPartnership.partner_model.move(params[:id], params[:relation], params[:destination_id])
						respond_to do |format|
							format.html { redirect_to request.referrer, notice: I18n.t("activerecord.notices.models.#{RicPartnership.partner_model.model_name.i18n_key}.move") }
							format.json { render json: true }
						end
					else
						respond_to do |format|
							format.html { redirect_to request.referrer, alert: I18n.t("activerecord.errors.models.#{RicPartnership.partner_model.model_name.i18n_key}.move") }
							format.json { render json: false }
						end
					end
				end
				
				def destroy
					@partner.destroy
					respond_to do |format|
						format.html { redirect_to ric_partnership.partners_path, notice: I18n.t("activerecord.notices.models.#{RicPartnership.partner_model.model_name.i18n_key}.destroy") }
						format.json { render json: @partner.id }
					end
				end

			protected

				def set_partner
					@partner = RicPartnership.partner_model.find_by_id(params[:id])
					if @partner.nil?
						redirect_to request.referrer, status: :see_other, alert: I18n.t("activerecord.errors.models.#{RicPartnership.partner_model.model_name.i18n_key}.not_found")
					end
				end

				def partner_params
					params.require(:partner).permit(RicPartnership.partner_model.permitted_columns)
				end

			end
		end
	end
end
