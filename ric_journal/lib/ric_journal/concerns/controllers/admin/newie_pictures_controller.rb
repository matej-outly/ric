# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Newie pictures
# *
# * Author: Matěj Outlý
# * Date  : 25. 8. 2015
# *
# *****************************************************************************

module RicJournal
	module Concerns
		module Controllers
			module Admin
				module NewiePicturesController extend ActiveSupport::Concern

					#
					# 'included do' causes the included code to be evaluated in the
					# context where it is included, rather than being executed in 
					# the module's context.
					#
					included do
					
						#
						# Set picture before some actions
						#
						before_action :set_newie_picture, only: [:show, :edit, :update, :destroy]

					end

					#
					# Show action
					#
					def show
						respond_to do |format|
							format.html { render "show" }
							format.json { render json: @newie_picture.to_json }
						end
					end

					#
					# New action
					#
					def new
						@newie_picture = RicJournal.newie_picture_model.new
						if params[:newie_id]
							@newie_picture.newie_id = params[:newie_id] 
						else
							redirect_to ric_journal_admin.newies_path, alert: I18n.t("activerecord.errors.models.#{RicJournal.newie_picture_model.model_name.i18n_key}.attributes.newie_id.blank")
						end
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
						@newie_picture = RicJournal.newie_picture_model.new(newie_picture_params)
						if @newie_picture.save
							respond_to do |format|
								format.html { redirect_to ric_journal_admin.newie_picture_path(@newie_picture), notice: I18n.t("activerecord.notices.models.#{RicJournal.newie_picture_model.model_name.i18n_key}.create") }
								format.json { render json: @newie_picture.id }
							end
						else
							respond_to do |format|
								format.html { render "new" }
								format.json { render json: @newie_picture.errors }
							end
						end
					end

					#
					# Update action
					#
					def update
						if @newie_picture.update(newie_picture_params)
							respond_to do |format|
								format.html { redirect_to ric_journal_admin.newie_picture_path(@newie_picture), notice: I18n.t("activerecord.notices.models.#{RicJournal.newie_picture_model.model_name.i18n_key}.update") }
								format.json { render json: @newie_picture.id }
							end
						else
							respond_to do |format|
								format.html { render "edit" }
								format.json { render json: @newie_picture.errors }
							end
						end
					end

					#
					# Destroy action
					#
					def destroy
						@newie_picture.destroy
						respond_to do |format|
							format.html { redirect_to ric_journal_admin.newie_path(@newie_picture.newie_id), notice: I18n.t("activerecord.notices.models.#{RicJournal.newie_picture_model.model_name.i18n_key}.destroy") }
							format.json { render json: @newie_picture.id }
						end
					end

				protected

					def set_newie_picture
						@newie_picture = RicJournal.newie_picture_model.find_by_id(params[:id])
						if @newie_picture.nil?
							redirect_to ric_journal_admin.newies_path, alert: I18n.t("activerecord.errors.models.#{RicJournal.newie_picture_model.model_name.i18n_key}.not_found")
						end
					end

					# 
					# Never trust parameters from the scary internet, only allow the white list through.
					#
					def newie_picture_params
						params.require(:newie_picture).permit(:newie_id, :picture, :title)
					end

				end
			end
		end
	end
end
