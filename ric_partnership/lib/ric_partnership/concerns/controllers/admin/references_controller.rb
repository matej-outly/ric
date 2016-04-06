# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * References
# *
# * Author: Matěj Outlý
# * Date  : 8. 3. 2015
# *
# *****************************************************************************

module RicPartnership
	module Concerns
		module Controllers
			module Admin
				module ReferencesController extend ActiveSupport::Concern

					#
					# 'included do' causes the included code to be evaluated in the
					# context where it is included, rather than being executed in 
					# the module's context.
					#
					included do
					
						#
						# Set reference before some actions
						#
						before_action :set_reference, only: [:show, :edit, :update, :destroy]

					end

					#
					# Index action
					#
					def index
						@references = RicPartnership.reference_model.all.order(position: :asc).page(params[:page]).per(50)
					end

					#
					# Show action
					#
					def show
						respond_to do |format|
							format.html { render "show" }
							format.json { render json: @reference.to_json }
						end
					end

					#
					# New action
					#
					def new
						@reference = RicPartnership.reference_model.new
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
						@reference = RicPartnership.reference_model.new(reference_params)
						if @reference.save
							respond_to do |format|
								format.html { redirect_to ric_partnership_admin.reference_path(@reference), notice: I18n.t("activerecord.notices.models.#{RicPartnership.reference_model.model_name.i18n_key}.create") }
								format.json { render json: @reference.id }
							end
						else
							respond_to do |format|
								format.html { render "new" }
								format.json { render json: @reference.errors }
							end
						end
					end

					#
					# Update action
					#
					def update
						if @reference.update(reference_params)
							respond_to do |format|
								format.html { redirect_to ric_partnership_admin.reference_path(@reference), notice: I18n.t("activerecord.notices.models.#{RicPartnership.reference_model.model_name.i18n_key}.update") }
								format.json { render json: @reference.id }
							end
						else
							respond_to do |format|
								format.html { render "edit" }
								format.json { render json: @reference.errors }
							end
						end
					end

					#
					# Move action
					#
					def move
						if RicPartnership.reference_model.move(params[:id], params[:relation], params[:destination_id])
							respond_to do |format|
								format.html { redirect_to ric_partnership_admin.references_path, notice: I18n.t("activerecord.notices.models.#{RicPartnership.reference_model.model_name.i18n_key}.move") }
								format.json { render json: true }
							end
						else
							respond_to do |format|
								format.html { redirect_to root_path, alert: I18n.t("activerecord.errors.models.#{RicPartnership.reference_model.model_name.i18n_key}.move") }
								format.json { render json: false }
							end
						end
					end
					
					#
					# Destroy action
					#
					def destroy
						@reference.destroy
						respond_to do |format|
							format.html { redirect_to ric_partnership_admin.references_path, notice: I18n.t("activerecord.notices.models.#{RicPartnership.reference_model.model_name.i18n_key}.destroy") }
							format.json { render json: @reference.id }
						end
					end

				protected

					def set_reference
						@reference = RicPartnership.reference_model.find_by_id(params[:id])
						if @reference.nil?
							redirect_to ric_partnership_admin.references_path, alert: I18n.t("activerecord.errors.models.#{RicPartnership.reference_model.model_name.i18n_key}.not_found")
						end
					end

					# 
					# Never trust parameters from the scary internet, only allow the white list through.
					#
					def reference_params
						params.require(:reference).permit(RicPartnership.reference_model.permitted_columns)
					end

				end
			end
		end
	end
end
