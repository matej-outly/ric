# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Branches
# *
# * Author: Matěj Outlý
# * Date  : 30. 6. 2015
# *
# *****************************************************************************

module RicContact
	module Concerns
		module Controllers
			module Admin
				module BranchesController extend ActiveSupport::Concern

					#
					# 'included do' causes the included code to be evaluated in the
					# context where it is included, rather than being executed in 
					# the module's context.
					#
					included do
					
						#
						# Set branch before some actions
						#
						before_action :set_branch, only: [:show, :edit, :update, :destroy]

					end

					#
					# Index action
					#
					def index
						@branches = RicContact.branch_model.all.order(name: :asc).page(params[:page]).per(50)
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
						@branch = RicContact.branch_model.new
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
						@branch = RicContact.branch_model.new(branch_params)
						if @branch.save
							redirect_to branch_path(@branch), notice: I18n.t("activerecord.notices.models.#{RicContact.branch_model.model_name.i18n_key}.create")
						else
							render "new"
						end
					end

					#
					# Update action
					#
					def update
						if @branch.update(branch_params)
							redirect_to branch_path(@branch), notice: I18n.t("activerecord.notices.models.#{RicContact.branch_model.model_name.i18n_key}.update")
						else
							render "edit"
						end
					end

					#
					# Destroy action
					#
					def destroy
						@branch.destroy
						redirect_to branches_path, notice: I18n.t("activerecord.notices.models.#{RicContact.branch_model.model_name.i18n_key}.destroy")
					end

				protected

					def set_branch
						@branch = RicContact.branch_model.find_by_id(params[:id])
						if @branch.nil?
							redirect_to branches_path, alert: I18n.t("activerecord.errors.models.#{RicContact.branch_model.model_name.i18n_key}.not_found")
						end
					end

					# 
					# Never trust parameters from the scary internet, only allow the white list through.
					#
					def branch_params
						params.require(:branch).permit(:name, :longitude, :latitude, :url, :address => [:street, :number, :city, :postcode])
					end

				end
			end
		end
	end
end
