# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Organizations
# *
# * Author: Matěj Outlý
# * Date  : 31. 7. 2017
# *
# *****************************************************************************

module RicOrganization
	module Concerns
		module Controllers
			module OrganizationsController extend ActiveSupport::Concern

				included do
					
					before_action :save_referrer, only: [:new, :edit]
					before_action :set_organization_list
					before_action :set_organization, only: [:show, :edit, :update, :move, :destroy]

				end

				def new
					@organization = RicOrganization.organization_model.new
					@organization.organization_list_id = @organization_list.id
				end

				def edit
				end

				def create
					@organization = RicOrganization.organization_model.new(organization_params)
					@organization.organization_list_id = @organization_list.id
					if @organization.save
						respond_to do |format|
							format.html { redirect_to load_referrer, notice: I18n.t("activerecord.notices.models.#{RicOrganization.organization_model.model_name.i18n_key}.create") }
							format.json { render json: @organization.id }
						end
					else
						respond_to do |format|
							format.html { render "new" }
							format.json { render json: @organization.errors }
						end
					end
				end

				def update
					if @organization.update(organization_params)
						respond_to do |format|
							format.html { redirect_to load_referrer, notice: I18n.t("activerecord.notices.models.#{RicOrganization.organization_model.model_name.i18n_key}.update") }
							format.json { render json: @organization.id }
						end
					else
						respond_to do |format|
							format.html { render "edit" }
							format.json { render json: @organization.errors }
						end
					end
				end

				def move
					if RicOrganization.organization_model.move(params[:id], params[:relation], params[:destination_id])
						respond_to do |format|
							format.html { redirect_to request.referrer, notice: I18n.t("activerecord.notices.models.#{RicOrganization.organization_model.model_name.i18n_key}.move") }
							format.json { render json: true }
						end
					else
						respond_to do |format|
							format.html { redirect_to request.referrer, alert: I18n.t("activerecord.errors.models.#{RicOrganization.organization_model.model_name.i18n_key}.move") }
							format.json { render json: false }
						end
					end
				end
				
				def destroy
					@organization.destroy
					respond_to do |format|
						format.html { redirect_to ric_organization_admin.organizations_path, notice: I18n.t("activerecord.notices.models.#{RicOrganization.organization_model.model_name.i18n_key}.destroy") }
						format.json { render json: @organization.id }
					end
				end

			protected

				def set_organization_list
					@organization_list = RicOrganization.organization_list_model.find_by_id(params[:organization_list_id])
					if @organization_list.nil?
						redirect_to request.referrer, status: :see_other, alert: I18n.t("activerecord.errors.models.#{RicOrganization.organization_model.model_name.i18n_key}.not_found")
					end
				end

				def set_organization
					@organization = RicOrganization.organization_model.find_by_id(params[:id])
					if @organization.nil? || @organization.organization_list_id != @organization_list.id
						redirect_to request.referrer, status: :see_other, alert: I18n.t("activerecord.errors.models.#{RicOrganization.organization_model.model_name.i18n_key}.not_found")
					end
				end

				def organization_params
					params.require(:organization).permit(RicOrganization.organization_model.permitted_columns)
				end

			end
		end
	end
end

