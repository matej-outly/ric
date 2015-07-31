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
			module Public
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
						before_action :set_gallery_directory, only: [:show]

					end

					#
					# Index action
					#
					def index
						@gallery_directories = RicGallery.gallery_directory_model.all.order(lft: :asc)
					end

					#
					# Show action
					#
					def show
					end

				protected

					def set_gallery_directory
						@gallery_directory = RicGallery.gallery_directory_model.find_by_id(params[:id])
						if @gallery_directory.nil?
							redirect_to directories_path, alert: I18n.t("activerecord.errors.models.#{RicGallery.gallery_directory_model.model_name.i18n_key}.not_found")
						end
					end

				end
			end
		end
	end
end
