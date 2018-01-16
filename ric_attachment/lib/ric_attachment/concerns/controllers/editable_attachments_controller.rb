# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Edit attachment interface
# *
# * Author: Matěj Outlý
# * Date  : 9. 10. 2017
# *
# *****************************************************************************

module RicAttachment
	module Concerns
		module Controllers
			module EditableAttachmentsController extend ActiveSupport::Concern

				included do
					before_action :set_subject
					before_action :set_session_id
					before_action :set_attachment, only: [:update, :destroy]
				end

				def create
					@attachment = RicAttachment.attachment_model.new(attachment_params)
					if @subject # Subject id a primary scope
						@attachment.subject = @subject 
					elsif @session_id # Session ID is a secondary scope
						@attachment.session_id = @session_id 
					end
					if @attachment.save
						respond_to do |format|
							format.html { redirect_to request.referrer, notice: RicAttachment.attachment_model.human_notice_message(:create) }
							format.json { render json: @attachment.id }
						end
					else
						respond_to do |format|
							format.html { redirect_to request.referrer, notice: RicAttachment.attachment_model.human_error_message(:create) }
							format.json { render json: @attachment.errors }
						end
					end
				end

				def update
					if @attachment.update(attachment_params)
						respond_to do |format|
							format.html { redirect_to request.referrer, notice: RicAttachment.attachment_model.human_notice_message(:update) }
							format.json { render json: @attachment.id }
						end
					else
						respond_to do |format|
							format.html { redirect_to request.referrer, notice: RicAttachment.attachment_model.human_error_message(:update) }
							format.json { render json: @attachment.errors }
						end
					end
				end

				def destroy
					@attachment.destroy
					respond_to do |format|
						format.html { redirect_to request.referrer, notice: RicAttachment.attachment_model.human_notice_message(:destroy) }
						format.json { render json: @attachment.id }
					end
				end

			protected

				# *************************************************************************
				# Model setters
				# *************************************************************************

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
				
				def set_attachment
					@attachment = RicAttachment.attachment_model.find_by_id(params[:id])
					not_found if @attachment.nil?
				end

				# *************************************************************************
				# Param filters
				# *************************************************************************

				def attachment_params
					params.require(RicAttachment.attachment_model.model_name.param_key).permit(RicAttachment.attachment_model.permitted_columns)
				end

			end
		end
	end
end
