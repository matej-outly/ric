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
					before_action :set_subject, only: [:index]
					before_action :set_session_id, only: [:index]
					before_action :set_attachment, only: [:show]
				end

				def index
					@attachments = RicAttachment.attachment_model.id(params[:id])
					#if @subject # Subject id a primary scope
					#	@attachments = @attachments.where(subject_type: @subject.class.to_s, subject_id: @subject.id)
					#elsif @session_id # Session ID is a secondary scope
					#	@attachments = @attachments.where(subject_id: nil, session_id: @session_id)
					#else
					#	@attachments = @attachments.where(subject_id: nil)
					#end
					@attachments = @attachments.order(id: :asc)
					respond_to do |format|
						format.json do
							render json: @attachments.map { |attachment|
								{
									id: attachment.id,
									html: render_to_string(
										partial: "index", 
										formats: [:html], 
										locals: { 
											subject: @subject,
											attachments: attachment, 
											options: { partial: true } 
										}
									)
								}
							}
						end
					end
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
				
				# *************************************************************************
				# Model setters
				# *************************************************************************

				def set_attachment
					@attachment = RicAttachment.attachment_model.find_by_id(params[:id])
				end

				def set_subject
					if params[:subject_id] && params[:subject_type]
						@subject_type = params[:subject_type].constantize rescue nil
						@subject = @subject_type.find_by_id(params[:subject_id]) if @subject_type
						not_found if @subject.nil?
					else
						@subject = nil
					end
				end

				def set_session_id
					@session_id = params[:session_id] if params[:session_id]
				end

			end
		end
	end
end
