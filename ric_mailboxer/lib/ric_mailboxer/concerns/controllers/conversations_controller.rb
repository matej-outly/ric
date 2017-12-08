# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Conversations
# *
# * Author: Matěj Outlý
# * Date  : 19. 2. 2017
# *
# *****************************************************************************

module RicMailboxer
	module Concerns
		module Controllers
			module ConversationsController extend ActiveSupport::Concern

				included do

					before_action :set_owner
					before_action :set_mailbox
					before_action :set_conversation, only: [:show, :reply, :update, :trash, :untrash, :destroy]

				end

				def show
					@conversations = @mailbox.conversations.not_trash(@owner)
					render "ric_mailboxer/mailboxes/show"
				end

				def create
					@ric_conversation = RicMailboxer.conversation_model.new
					@ric_conversation.sender_id = @owner.id
					if @ric_conversation.create(conversation_params)
						respond_to do |format|
							format.html { redirect_to request.referrer, notice: RicMailboxer.conversation_model.human_notice_message(:create) }
							format.json { render json: @ric_conversation.id }
						end
					else
						respond_to do |format|
							format.html { redirect_to request.referrer, alert: RicMailboxer.conversation_model.human_error_message(:create) }
							format.json { render json: @ric_conversation.errors }
						end
					end
				end

				def update
					@ric_conversation = RicMailboxer.conversation_model.new(@conversation)
					@ric_conversation.sender_id = @owner.id
					if @ric_conversation.update(conversation_params)
						respond_to do |format|
							format.html { redirect_to request.referrer, notice: RicMailboxer.conversation_model.human_notice_message(:update) }
							format.json { render json: @ric_conversation.id }
						end
					else
						respond_to do |format|
							format.html { redirect_to request.referrer, alert: RicMailboxer.conversation_model.human_error_message(:update) }
							format.json { render json: @ric_conversation.errors }
						end
					end
				end

				def reply
					@ric_conversation = RicMailboxer.conversation_model.new(@conversation)
					@ric_conversation.sender_id = @owner.id
					if @ric_conversation.reply(conversation_params)
						respond_to do |format|
							format.html { redirect_to request.referrer, notice: RicMailboxer.conversation_model.human_notice_message(:update) }
							format.json { render json: @ric_conversation.id }
						end
					else
						respond_to do |format|
							format.html { redirect_to request.referrer, alert: RicMailboxer.conversation_model.human_error_message(:update) }
							format.json { render json: @ric_conversation.errors }
						end
					end
				end

				def trash
					@conversation.move_to_trash(@owner)
					respond_to do |format|
						format.html { redirect_to request.referrer, notice: RicMailboxer.conversation_model.human_notice_message(:trash) }
						format.json { render json: @conversation.id }
					end
				end

				def untrash
					@conversation.untrash(@owner)
					respond_to do |format|
						format.html { redirect_to request.referrer, notice: RicMailboxer.conversation_model.human_notice_message(:untrash) }
						format.json { render json: @conversation.id }
					end
				end

				def destroy
					@conversation.mark_as_deleted(@owner)
					respond_to do |format|
						format.html { redirect_to request.referrer, notice: RicMailboxer.conversation_model.human_notice_message(:destroy) }
						format.json { render json: @conversation.id }
					end
				end

			protected

				# *************************************************************
				# Model setters
				# *************************************************************
				
				def set_owner
					if RicMailboxer.use_person
						@owner = current_user.person
						@owner = current_user if @owner.nil?
					else
						@owner = current_user
					end
				end

				def set_mailbox
					@mailbox = @owner.mailbox
				end

				def set_conversation
					@conversation = @mailbox.conversations.find_by_id(params[:id])
					not_found if @conversation.nil?
				end

				# *************************************************************
				# Param filters
				# *************************************************************

				def conversation_params
					RicMailboxer.conversation_model.process_params(params.require(RicMailboxer.conversation_model.model_name.param_key).permit(RicMailboxer.conversation_model.permitted_columns))
				end

			end
		end
	end
end