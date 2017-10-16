# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Froala editor interface
# *
# * Author: Matěj Outlý
# * Date  : 9. 10. 2017
# *
# *****************************************************************************

module RicAttachment
	module Concerns
		module Controllers
			module FroalaController extend ActiveSupport::Concern

				included do
					
					# Cannot be checked because froala editor does not provide token in POST data
					skip_before_action :verify_authenticity_token

					# Set some models before actions
					before_action :set_subject
					before_action :set_session_id

				end

				def index
					@attachments = RicAttachment.attachment_model.all
					if @subject # Subject id a primary scope
						@attachments = @attachments.where(subject_type: @subject.class.to_s, subject_id: @subject.id)
					elsif @session_id # Session ID is a secondary scope
						@attachments = @attachments.where(subject_id: nil, session_id: @session_id)
					else
						@attachments = @attachments.where(subject_id: nil)
					end
					@attachments = @attachments.where(kind: params[:kind]) if params[:kind]
					@attachments = @attachments.order(created_at: :asc)
					result = []
					@attachments.each do |attachment|
						result << { url: ric_attachment.attachment_path(attachment) }
					end
					render json: result.to_json
				end

				def create
					if params[:file]
						@attachment = RicAttachment.attachment_model.new
						@attachment.file = params[:file]
						if @subject # Subject id a primary scope
							@attachment.subject = @subject 
						elsif @session_id # Session ID is a secondary scope
							@attachment.session_id = @session_id 
						end
						if @attachment.save
							render json: { link: ric_attachment.attachment_path(@attachment) }
						else
							render json: false
						end
					else
						render json: false
					end
				end

				def destroy
					if params[:src]
						matched = params[:src].match("attachments\/(.*)")
						if matched
							id = matched[1].to_i
							@attachment = RicAttachment.attachment_model.find_by_id(id)
							if @attachment
								@attachment.destroy
								render json: true
							else
								render json: false
							end
						else
							render json: false
						end
					else
						render json: false
					end
				end

			protected

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
