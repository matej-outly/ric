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

module RicReference
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
					
						before_action :set_reference, only: [:show, :edit, :update, :destroy]

					end

					def index
						@references = RicReference.reference_model.all.order(position: :asc).page(params[:page]).per(50)
					end

					def show
						respond_to do |format|
							format.html { render "show" }
							format.json { render json: @reference.to_json }
						end
					end

					def new
						@reference = RicReference.reference_model.new
					end

					def edit
					end

					def create
						@reference = RicReference.reference_model.new(reference_params)
						if @reference.save
							respond_to do |format|
								format.html { redirect_to ric_reference_admin.reference_path(@reference), notice: I18n.t("activerecord.notices.models.#{RicReference.reference_model.model_name.i18n_key}.create") }
								format.json { render json: @reference.id }
							end
						else
							respond_to do |format|
								format.html { render "new" }
								format.json { render json: @reference.errors }
							end
						end
					end

					def update
						if @reference.update(reference_params)
							respond_to do |format|
								format.html { redirect_to ric_reference_admin.reference_path(@reference), notice: I18n.t("activerecord.notices.models.#{RicReference.reference_model.model_name.i18n_key}.update") }
								format.json { render json: @reference.id }
							end
						else
							respond_to do |format|
								format.html { render "edit" }
								format.json { render json: @reference.errors }
							end
						end
					end

					def move
						if RicReference.reference_model.move(params[:id], params[:relation], params[:destination_id])
							respond_to do |format|
								format.html { redirect_to ric_reference_admin.references_path, notice: I18n.t("activerecord.notices.models.#{RicReference.reference_model.model_name.i18n_key}.move") }
								format.json { render json: true }
							end
						else
							respond_to do |format|
								format.html { redirect_to ric_reference_admin.references_path, alert: I18n.t("activerecord.errors.models.#{RicReference.reference_model.model_name.i18n_key}.move") }
								format.json { render json: false }
							end
						end
					end
					
					def destroy
						@reference.destroy
						respond_to do |format|
							format.html { redirect_to ric_reference_admin.references_path, notice: I18n.t("activerecord.notices.models.#{RicReference.reference_model.model_name.i18n_key}.destroy") }
							format.json { render json: @reference.id }
						end
					end

				protected

					def set_reference
						@reference = RicReference.reference_model.find_by_id(params[:id])
						if @reference.nil?
							redirect_to ric_reference_admin.references_path, alert: I18n.t("activerecord.errors.models.#{RicReference.reference_model.model_name.i18n_key}.not_found")
						end
					end

					def reference_params
						params.require(:reference).permit(RicReference.reference_model.permitted_columns)
					end

				end
			end
		end
	end
end
