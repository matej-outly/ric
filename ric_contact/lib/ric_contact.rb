# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * RicContact
# *
# * Author: Matěj Outlý
# * Date  : 30. 6. 2015
# *
# *****************************************************************************

# Engines
require "ric_contact/admin_engine"
require "ric_contact/public_engine"

# Models
require "ric_contact/concerns/models/contact_message"
require "ric_contact/concerns/models/contact_message_tableless"

# Mailers
require "ric_contact/concerns/mailers/contact_message_mailer"

module RicContact

	#
	# This will keep Rails Engine from generating all table prefixes with the engines name
	#
	def self.table_name_prefix
	end

	# *************************************************************************
	# Configuration
	# *************************************************************************

	#
	# Default way to setup module
	#
	def self.setup
		yield self
	end

	# *************************************************************************
	# Config options
	# *************************************************************************

	#
	# Contact message model
	#
	mattr_accessor :contact_message_model
	def self.contact_message_model
		return @@contact_message_model.constantize
	end
	@@contact_message_model = "RicContact::ContactMessage"

	#
	# Contact message mailer
	#
	mattr_accessor :contact_message_mailer
	def self.contact_message_mailer
		return @@contact_message_mailer.constantize
	end
	@@contact_message_mailer = "RicContact::ContactMessageMailer"

	#
	# Save contact messages to DB
	#
	mattr_accessor :save_contact_messages_to_db
	@@save_contact_messages_to_db = false

	#
	# Send copy of contact contact messages to user who created it
	#
	mattr_accessor :send_contact_messages_copy_to_author
	@@send_contact_messages_copy_to_author = false

	#
	# Send notification of contact contact messages to user who created it
	#
	mattr_accessor :send_contact_messages_notification_to_author
	@@send_contact_messages_notification_to_author = false

	#
	# Model attribute definition. must be correctly defined in both (tableless and standard) variants
	#
	mattr_accessor :contact_message_attributes
	@@contact_message_attributes = [
		{
			name: "name",
			type: "string",
		},
		{
			name: "email",
			type: "string",
		},
		{
			name: "message",
			type: "string",
			required: true,
		}
	]

	#
	# Which users should receive contact message
	#
	mattr_accessor :contact_message_receivers
	@@contact_message_receivers = lambda { [] }

	#
	# Mailer sender - only valid if RicNotification not used
	#
	mattr_accessor :mailer_sender
	#@@mailer_sender = ... to be set in module initializer

	#
	# Mailer sender name - only valid if RicNotification not used
	#
	mattr_accessor :mailer_sender_name
	#@@mailer_sender_name = ... to be set in module initializer

	#
	# Mailer receiver - only valid if RicNotification not used
	#
	mattr_accessor :mailer_receiver
	#@@mailer_receiver = ... to be set in module initializer

	#
	# Use reCAPTCHA for contact message form
	#
	mattr_accessor :recaptcha
	@@recaptcha = false

	#
	# Name of reCAPTCHA virtual attribute
	#
	mattr_accessor :recaptcha_attribute
	@@recaptcha_attribute = "recaptcha"

	#
	# Class or object implementing actions_options, tabs_options, etc. can be set.
	#
	mattr_accessor :theme
	def self.theme
		if @@theme
			return @@theme.constantize if @@theme.is_a?(String)
			return @@theme
		end
		return OpenStruct.new
	end
	@@theme = nil

end
