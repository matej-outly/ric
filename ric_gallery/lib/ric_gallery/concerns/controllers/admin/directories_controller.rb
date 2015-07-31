# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Directories
# *
# * Author: Matěj Outlý
# * Date  : 30. 6. 2015
# *
# *****************************************************************************

module RicGallery
	module Concerns
		module Controllers
			module Admin
				module DirectoriesController extend ActiveSupport::Concern

					#
					# 'included do' causes the included code to be evaluated in the
					# context where it is included, rather than being executed in 
					# the module's context.
					#
					included do
					
						#
						# Set directory before some actions
						#
						before_action :set_directory, only: [:show, :edit, :update, :destroy]

					end

					#
					# Index action
					#
					def index
						@directories = RicGallery.directory_model.all.order(published_at: :desc).page(params[:page]).per(50)
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
						@directory = RicGallery.directory_model.new
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
						@directory = RicGallery.directory_model.new(directory_params)
						if @directory.save
							redirect_to directory_path(@directory), notice: I18n.t("activerecord.notices.models.#{RicGallery.directory_model.model_name.i18n_key}.create")
						else
							render "new"
						end
					end

					#
					# Update action
					#
					def update
						if @directory.update(directory_params)
							redirect_to directory_path(@directory), notice: I18n.t("activerecord.notices.models.#{RicGallery.directory_model.model_name.i18n_key}.update")
						else
							render "edit"
						end
					end

					#
					# Destroy action
					#
					def destroy
						@directory.destroy
						redirect_to directories_path, notice: I18n.t("activerecord.notices.models.#{RicGallery.directory_model.model_name.i18n_key}.destroy")
					end

				protected

					def set_directory
						@directory = RicGallery.directory_model.find_by_id(params[:id])
						if @directory.nil?
							redirect_to directories_path, alert: I18n.t("activerecord.errors.models.#{RicGallery.directory_model.model_name.i18n_key}.not_found")
						end
					end

					# 
					# Never trust parameters from the scary internet, only allow the white list through.
					#
					def directory_params
						params.require(:directory).permit(:title, :perex, :content, :published_at)
					end

				end
			end
		end
	end
end
