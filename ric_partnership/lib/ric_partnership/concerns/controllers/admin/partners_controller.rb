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
			module Admin
				module PartnersController extend ActiveSupport::Concern

					#
					# 'included do' causes the included code to be evaluated in the
					# context where it is included, rather than being executed in 
					# the module's context.
					#
					included do
					
						#
						# Set partner before some actions
						#
						before_action :set_partner, only: [:show, :edit, :update, :destroy]

					end

					#
					# Index action
					#
					def index
						@partners = RicPartnership.partner_model.all.order(position: :asc).page(params[:page]).per(50)
					end

					#
					# Show action
					#
					def show
						respond_to do |format|
							format.html { render "show" }
							format.json { render json: @partner.to_json }
						end
					end

					#
					# New action
					#
					def new
						@partner = RicPartnership.partner_model.new
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
						@partner = RicPartnership.partner_model.new(partner_params)
						if @partner.save
							respond_to do |format|
								format.html { redirect_to ric_partnership_admin.partner_path(@partner), notice: I18n.t("activerecord.notices.models.#{RicPartnership.partner_model.model_name.i18n_key}.create") }
								format.json { render json: @partner.id }
							end
						else
							respond_to do |format|
								format.html { render "new" }
								format.json { render json: @partner.errors }
							end
						end
					end

					#
					# Update action
					#
					def update
						if @partner.update(partner_params)
							respond_to do |format|
								format.html { redirect_to ric_partnership_admin.partner_path(@partner), notice: I18n.t("activerecord.notices.models.#{RicPartnership.partner_model.model_name.i18n_key}.update") }
								format.json { render json: @partner.id }
							end
						else
							respond_to do |format|
								format.html { render "edit" }
								format.json { render json: @partner.errors }
							end
						end
					end

					#
					# Move action
					#
					def move
						if RicPartnership.partner_model.move(params[:id], params[:relation], params[:destination_id])
							respond_to do |format|
								format.html { redirect_to ric_partnership_admin.partners_path, notice: I18n.t("activerecord.notices.models.#{RicPartnership.partner_model.model_name.i18n_key}.move") }
								format.json { render json: true }
							end
						else
							respond_to do |format|
								format.html { redirect_to root_path, alert: I18n.t("activerecord.errors.models.#{RicPartnership.partner_model.model_name.i18n_key}.move") }
								format.json { render json: false }
							end
						end
					end
					
					#
					# Destroy action
					#
					def destroy
						@partner.destroy
						respond_to do |format|
							format.html { redirect_to ric_partnership_admin.partners_path, notice: I18n.t("activerecord.notices.models.#{RicPartnership.partner_model.model_name.i18n_key}.destroy") }
							format.json { render json: @partner.id }
						end
					end

				protected

					def set_partner
						@partner = RicPartnership.partner_model.find_by_id(params[:id])
						if @partner.nil?
							redirect_to ric_partnership_admin.partners_path, alert: I18n.t("activerecord.errors.models.#{RicPartnership.partner_model.model_name.i18n_key}.not_found")
						end
					end

					# 
					# Never trust parameters from the scary internet, only allow the white list through.
					#
					def partner_params
						params.require(:partner).permit(RicPartnership.partner_model.permitted_columns)
					end

				end
			end
		end
	end
end
