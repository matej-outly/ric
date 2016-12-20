# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Slugs
# *
# * Author: Matěj Outlý
# * Date  : 22. 4. 2016
# *
# *****************************************************************************

module RicUrl
	module Concerns
		module Controllers
			module Admin
				module SlugsController extend ActiveSupport::Concern

					#
					# 'included do' causes the included code to be evaluated in the
					# context where it is included, rather than being executed in 
					# the module's context.
					#
					included do
					
						#
						# Set slug before some actions
						#
						before_action :set_slug, only: [:show, :edit, :update, :destroy]

					end

					#
					# Index action
					#
					def index
						@filter_slug = RicUrl.slug_model.new(load_params_from_session)
						@slugs = RicUrl.slug_model.filter(load_params_from_session.symbolize_keys).order(original: :asc).page(params[:page]).per(50)
					end

					#
					# Filter action
					#
					def filter
						save_params_to_session(filter_params)
						redirect_to ric_url_admin.slugs_path
					end

					#
					# New action
					#
					def new
						@slug = RicUrl.slug_model.new
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
						@slug = RicUrl.slug_model.new(slug_params)
						if @slug.save
							respond_to do |format|
								format.html { redirect_to ric_slug_admin.slugs_path, notice: I18n.t("activerecord.notices.models.#{RicUrl.slug_model.model_name.i18n_key}.create") }
								format.json { render json: @slug.id }
							end
						else
							respond_to do |format|
								format.html { render "new" }
								format.json { render json: @slug.errors }
							end
						end
					end

					#
					# Update action
					#
					def update
						if @slug.update(slug_params)
							respond_to do |format|
								format.html { redirect_to ric_slug_admin.slugs_path, notice: I18n.t("activerecord.notices.models.#{RicUrl.slug_model.model_name.i18n_key}.update") }
								format.json { render json: @slug.id }
							end
						else
							respond_to do |format|
								format.html { render "edit" }
								format.json { render json: @slug.errors }
							end
						end
					end

					#
					# Destroy action
					#
					def destroy
						@slug.destroy
						respond_to do |format|
							format.html { redirect_to ric_slug_admin.slugs_path, notice: I18n.t("activerecord.notices.models.#{RicUrl.slug_model.model_name.i18n_key}.destroy") }
							format.json { render json: @slug.id }
						end
					end

				protected

					# *********************************************************
					# Model setters
					# *********************************************************

					def set_slug
						@slug = RicUrl.slug_model.find_by_id(params[:id])
						if @slug.nil?
							redirect_to ric_slug_admin.slugs_path, alert: I18n.t("activerecord.errors.models.#{RicUrl.slug_model.model_name.i18n_key}.not_found")
						end
					end

					# *********************************************************
					# Session
					# *********************************************************

					def session_key
						return "slugs"
					end

					def save_params_to_session(params)
						if session[session_key].nil?
							session[session_key] = {}
						end
						if !params.nil?
							session[session_key]["params"] = params
						end
					end

					def load_params_from_session
						if !session[session_key].nil? && !session[session_key]["params"].nil?
							return session[session_key]["params"]
						else
							return {}
						end
					end

					# *********************************************************
					# Param filters
					# *********************************************************

					def slug_params
						params.require(:slug).permit(RicUrl.slug_model.permitted_columns)
					end

					def filter_params
						params[:slug].permit(RicUrl.slug_model.filter_columns)
					end

				end
			end
		end
	end
end