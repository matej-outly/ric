# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Contact people
# *
# * Author: Matěj Outlý
# * Date  : 30. 6. 2015
# *
# *****************************************************************************

module RicContact
	module Concerns
		module Controllers
			module Admin
				module ContactPeopleController extend ActiveSupport::Concern

					#
					# 'included do' causes the included code to be evaluated in the
					# context where it is included, rather than being executed in 
					# the module's context.
					#
					included do
					
						before_action :set_contact_person, only: [:show, :edit, :update, :move, :destroy]

					end

					def index
						@contact_people = RicContact.contact_person_model.all.order(position: :asc)
					end

					def show
						respond_to do |format|
							format.html { render "show" }
							format.json { render json: @contact_person.to_json(methods: :photo_url) }
						end
					end

					def new
						@contact_person = RicContact.contact_person_model.new
					end

					def edit
					end

					def create
						@contact_person = RicContact.contact_person_model.new(contact_person_params)
						if @contact_person.save
							respond_to do |format|
								format.html { redirect_to ric_contact_admin.contact_person_path(@contact_person), notice: I18n.t("activerecord.notices.models.#{RicContact.contact_person_model.model_name.i18n_key}.create") }
								format.json { render json: @contact_person.id }
							end
						else
							respond_to do |format|
								format.html { render "new" }
								format.json { render json: @contact_person.errors }
							end
						end
					end

					def update
						if @contact_person.update(contact_person_params)
							respond_to do |format|
								format.html { redirect_to ric_contact_admin.contact_person_path(@contact_person), notice: I18n.t("activerecord.notices.models.#{RicContact.contact_person_model.model_name.i18n_key}.update") }
								format.json { render json: @contact_person.id }
							end
						else
							respond_to do |format|
								format.html { render "edit" }
								format.json { render json: @contact_person.errors }
							end
						end
					end

					def move
						if RicContact.contact_person_model.move(params[:id], params[:relation], params[:destination_id])
							respond_to do |format|
								format.html { redirect_to ric_contact_admin.contact_people_path, notice: I18n.t("activerecord.notices.models.#{RicContact.contact_person_model.model_name.i18n_key}.move") }
								format.json { render json: @contact_person.id }
							end
						else
							respond_to do |format|
								format.html { redirect_to root_path, alert: I18n.t("activerecord.errors.models.#{RicContact.contact_person_model.model_name.i18n_key}.move") }
								format.json { render json: @contact_person.errors }
							end
						end
					end

					def destroy
						@contact_person.destroy
						respond_to do |format|
							format.html { redirect_to ric_contact_admin.contact_people_path, notice: I18n.t("activerecord.notices.models.#{RicContact.contact_person_model.model_name.i18n_key}.destroy") }
							format.json { render json: @contact_person.id }
						end
					end

				protected

					def set_contact_person
						@contact_person = RicContact.contact_person_model.find_by_id(params[:id])
						if @contact_person.nil?
							redirect_to contact_people_path, alert: I18n.t("activerecord.errors.models.#{RicContact.contact_person_model.model_name.i18n_key}.not_found")
						end
					end

					def contact_person_params
						params.require(:contact_person).permit(RicContact.contact_person_model.permitted_columns)
					end

				end
			end
		end
	end
end
