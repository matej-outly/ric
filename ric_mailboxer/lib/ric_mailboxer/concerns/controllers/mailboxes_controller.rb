# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Mailbox
# *
# * Author: Matěj Outlý
# * Date  : 19. 2. 2017
# *
# *****************************************************************************

module RicMailboxer
	module Concerns
		module Controllers
			module MailboxesController extend ActiveSupport::Concern

				included do

					before_action :set_owner
					before_action :set_mailbox

				end

				def show # == inbox
					@conversations = @mailbox.conversations.not_trash(@owner)
					@conversation = @conversations.first
				end

				def trash
					@conversations = @mailbox.trash
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

			end
		end
	end
end