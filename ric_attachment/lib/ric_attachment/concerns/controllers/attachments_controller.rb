# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Read attachment interface
# *
# * Author: Matěj Outlý
# * Date  : 9. 10. 2017
# *
# *****************************************************************************

module RicAttachment
	module Concerns
		module Controllers
			module AttachmentsController extend ActiveSupport::Concern

				included do
					before_action :set_attachment, only: [:show]
				end

				def show
					if @attachment && @attachment.file.exists?
						#redirect_to @attachment.file.url
						send_file @attachment.file.path, type: @attachment.file_content_type, disposition: "inline"
					else
						render plain: "", status: :not_found
					end
				end

			protected
				
				def set_attachment
					@attachment = RicAttachment.attachment_model.find_by_id(params[:id])
				end

			end
		end
	end
end
