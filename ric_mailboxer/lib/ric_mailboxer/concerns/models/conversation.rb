# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Wrapper object for conversation model. Creates unified interface for 
# * manipulation in controllers and forms.
# *
# * Author: Matěj Outlý
# * Date  : 8. 12. 2017
# *
# *****************************************************************************

module RicMailboxer
	module Concerns
		module Models
			module Conversation extend ActiveSupport::Concern

				included do

					validates_presence_of :recipient_ids, :sender_id, :subject, :body
					
				end

				module ClassMethods

					def permitted_columns
						[
							:recipient_ids,
							:subject,
							:body
						]
					end

					def process_params(params)
						params[:recipient_ids] = params[:recipient_ids].split(",") if params[:recipient_ids] && params[:recipient_ids].is_a?(String)
						return params
					end

				end

				#
				# Expects Mailboxer::Conversation as backend
				#
				def initialize(backend = nil, params = {})
					@backend = backend
					self.assign_attributes(params)
				end

				def id
					return @id ||= @backend ? @backend.id : nil
				end

				def new_record?
					return self.id.nil?
				end

				# *************************************************************
				# Sender
				# *************************************************************

				def sender_id
					return @sender_id
				end

				def sender_id=(value)
					@sender_id = value
				end

				def sender
					return self.sender_id ? User.find_by_id(self.sender_id) : nil
				end

				# *************************************************************
				# Recipients
				# *************************************************************

				def recipient_ids
					return @recipient_ids ||= @backend ? @backend.recipients.map{ |r| r.id } : nil
				end

				def recipient_ids=(value)
					@recipient_ids = value
				end

				def recipients
					return self.recipient_ids ? User.where(id: self.recipient_ids) : nil
				end

				# *************************************************************
				# Subject
				# *************************************************************

				def subject
					return @subject ||= @backend ? @backend.subject : nil
				end

				def subject=(value)
					@subject = value
				end

				# *************************************************************
				# Body
				# *************************************************************

				def body
					return @body ||= @backend ? @backend.last_message.body : nil
				end

				def body=(value)
					@body = value
				end

				# *************************************************************
				# Lifecycle
				# *************************************************************

				def create(params = nil)
					return false if !self.new_record?
					self.assign_attributes(params) if !params.nil?
					return false if !self.valid?
					
					# Send message
					self.sender.send_message(self.recipients, self.body, self.subject)

					# Fake ID
					@id = 1

					return true
				end

				def reply(params = nil)
					return false if self.new_record?
					self.assign_attributes(params) if !params.nil?
					return false if !self.valid?
					
					# Reply to a conversation
					self.sender.reply_to_conversation(@backend, self.body)
					
					return true
				end

				def update(params = nil)
					return false if self.new_record?
					self.assign_attributes(params) if !params.nil?
					return false if !self.valid?

					# Update conversation
					@backend.update(subject: self.subject)

					return true
				end

			end
		end
	end
end