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

				before_action :set_files_and_folders, only: [:index, :show]

				def index
				end

				def show
				end

				def new
					@document_folder = DocumentFolder.new
				end

				def create
					@document_folder = DocumentFolder.new(document_folder_params)
					if @document_folder.save
						redirect_to @document_folder
					else
						render "new"
					end
				end

				def destroy
					document_folder = DocumentFolder.find(params[:id]).destroy
					redirect_to (document_folder.parent || document_folders_url)
				end


			protected

				#
				# Set current folder, files and folders into view
				#
				def set_files_and_folders
					@current_folder = params[:id] ? DocumentFolder.find(params[:id]) : nil
					@folders = DocumentFolder.where(parent_id: params[:id]).order(:name)
					@files = Document.where(document_folder_id: params[:id]).order(:name)
				end


			private

				def document_folder_params
					params.require(:document_folder).permit(DocumentFolder.permitted_columns)
				end

			end
		end
	end
end