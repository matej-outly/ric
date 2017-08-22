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
					
					before_action :set_organization, only: [:edit, :update, :move, :destroy]

				end

				# *************************************************************
				# Actions
				# *************************************************************

				def index
					@filter_organization = RicOrganization.organization_model.new(load_params_from_session)
					@organizations = RicOrganization.organization_model.filter(load_params_from_session).order(name: :asc).page(params[:page]).per(50)
				end

				def filter
					save_params_to_session(filter_params)
					redirect_to organizations_path
				end

				def create
					@organization = RicOrganization.organization_model.new(organization_params)
					if @organization.save
						respond_to do |format|
							format.html { redirect_to request.referrer, notice: RicOrganization.organization_model.human_notice_message(:create) }
							format.json { render json: @organization.id }
						end
					else
						respond_to do |format|
							format.html { redirect_to request.referrer, alert: RicOrganization.organization_model.human_error_message(:create) }
							format.json { render json: @organization.errors }
						end
					end
				end

				def update
					if @organization.update(organization_params)
						respond_to do |format|
							format.html { redirect_to request.referrer, notice: RicOrganization.organization_model.human_notice_message(:update) }
							format.json { render json: @organization.id }
						end
					else
						respond_to do |format|
							format.html { redirect_to request.referrer, alert: RicOrganization.organization_model.human_error_message(:update) }
							format.json { render json: @organization.errors }
						end
					end
				end

				def move
					if RicOrganization.organization_model.move(params[:id], params[:relation], params[:destination_id])
						respond_to do |format|
							format.html { redirect_to request.referrer, notice: RicOrganization.organization_model.human_notice_message(:move) }
							format.json { render json: true }
						end
					else
						respond_to do |format|
							format.html { redirect_to request.referrer, alert: RicOrganization.organization_model.human_error_message(:move) }
							format.json { render json: false }
						end
					end
				end
				
				def destroy
					@organization.destroy
					respond_to do |format|
						format.html { redirect_to request.referrer, notice: RicOrganization.organization_model.human_notice_message(:destroy) }
						format.json { render json: @organization.id }
					end
				end

			protected

				# *************************************************************
				# Model setters
				# *************************************************************

				def set_organization
					@organization = RicOrganization.organization_model.find_by_id(params[:id])
					not_found if @organization.nil?
				end

				# *************************************************************
				# Param filters
				# *************************************************************

				def organization_params
					params.require(:organization).permit(RicOrganization.organization_model.permitted_columns)
				end

				def filter_params
					params.require(:organization).permit(RicOrganization.organization_model.filter_columns)
				end

			end
		end
	end
end

