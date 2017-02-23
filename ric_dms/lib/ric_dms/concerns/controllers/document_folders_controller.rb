# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Documents
# *
# * Author:
# * Date  : 19. 2. 2017
# *
# *****************************************************************************

module RicDms
	module Concerns
		module Controllers
			module DocumentFoldersController extend ActiveSupport::Concern

				included do

					# Directory listing
					before_action :set_files_and_folders, only: [:index, :show]

				end

				# *************************************************************************
				# Actions
				# *************************************************************************


				def index
					if !(can_read? || can_read_and_write?)
						not_authorized!
					end
				end

				def show
					if can_read? || can_read_and_write?
						render "index"
					else
						not_authorized!
					end
				end

				def new
					if can_read_and_write?
						@document_folder = RicDms.document_folder_model.new
					else
						not_authorized!
					end
				end

				def create
					if can_read_and_write?
						@document_folder = RicDms.document_folder_model.new(document_folder_params)
						if @document_folder.save
							redirect_to @document_folder
						else
							render "new"
						end
					else
						not_authorized!
					end
				end

				def destroy
					if can_read_and_write?
						document_folder = RicDms.document_folder_model.find(params[:id]).destroy
						redirect_to (document_folder.parent || document_folders_url)
					else
						not_authorized!
					end
				end


			protected

				#
				# Set current folder, files and folders into view
				#
				def set_files_and_folders
					@current_folder = params[:id] ? RicDms.document_folder_model.find(params[:id]) : nil
					@folders = RicDms.document_folder_model.where(parent_id: params[:id]).order(:name)
					@files = RicDms.document_model.where(document_folder_id: params[:id]).order(:name)
				end


			private

				def document_folder_params
					params.require(:document_folder).permit(RicDms.document_folder_model.permitted_columns)
				end

			end
		end
	end
end