# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Node attachments
# *
# * Author: Matěj Outlý
# * Date  : 19. 1. 2017
# *
# *****************************************************************************

module RicWebsite
	module Concerns
		module Controllers
			module Public
				module NodeAttachmentsController extend ActiveSupport::Concern
					
					#
					# 'included do' causes the included code to be evaluated in the
					# context where it is included, rather than being executed in 
					# the module's context.
					#
					included do
						before_action :set_node_attachment, only: [:show]
					end

					def show
						if @node_attachment && @node_attachment.attachment.exists?
							redirect_to @node_attachment.attachment.url
							#send_file @node_attachment.attachment.path, type: @node_attachment.attachment_content_type, disposition: "inline"
						else
							render plain: "", status: :not_found
						end
					end

				protected

					# *************************************************************************
					# Model setters
					# *************************************************************************

					def set_node_attachment
						@node_attachment = RicWebsite.node_attachment_model.find_by_id(params[:id])
					end

				end
			end
		end
	end
end
