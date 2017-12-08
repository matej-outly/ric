# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * RicNotification
# *
# * Author: Matěj Outlý
# * Date  : 9. 6. 2015
# *
# *****************************************************************************

# Engine
require "ric_notification/engine"

# Models
require "ric_notification/concerns/models/notification"
require "ric_notification/concerns/models/notification_delivery"
require "ric_notification/concerns/models/notification_delivery/batch"
require "ric_notification/concerns/models/notification_delivery/instantly"
require "ric_notification/concerns/models/notification_receiver"
require "ric_notification/concerns/models/notification_receiver/email"
require "ric_notification/concerns/models/notification_receiver/mailboxer"
require "ric_notification/concerns/models/notification_receiver/sms"
require "ric_notification/concerns/models/notification_template"

# Services
require "ric_notification/concerns/services/notification"
require "ric_notification/concerns/services/delivery"

# Mailers
require "ric_notification/concerns/mailers/notification_mailer"

module RicNotification

	#
	# This will keep Rails Engine from generating all table prefixes with the engines name
	#
	def self.table_name_prefix
	end

	# *************************************************************************
	# Services
	# *************************************************************************

	include RicNotification::Concerns::Services::Notification
	include RicNotification::Concerns::Services::Delivery

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
	# Notification model
	#
	mattr_accessor :notification_model
	def self.notification_model
		return @@notification_model.constantize
	end
	@@notification_model = "RicNotification::Notification"

	#
	# Notification delivery model
	#
	mattr_accessor :notification_delivery_model
	def self.notification_delivery_model
		return @@notification_delivery_model.constantize
	end
	@@notification_delivery_model = "RicNotification::NotificationDelivery"

	#
	# Notification receiver model
	#
	mattr_accessor :notification_receiver_model
	def self.notification_receiver_model
		return @@notification_receiver_model.constantize
	end
	@@notification_receiver_model = "RicNotification::NotificationReceiver"

	#
	# Notification template model
	#
	mattr_accessor :notification_template_model
	def self.notification_template_model
		return @@notification_template_model.constantize
	end
	@@notification_template_model = "RicNotification::NotificationTemplate"

	#
	# Available notification template refs. For each defined ref there will be 
	# an automatically created record in the notification_templates table. 
	# System administrator can define content of this template via admin 
	# interface.
	#
	mattr_accessor :template_refs
	@@template_refs = [
#		:some_notification_ref_1,
#		:some_notification_ref_2,
	]

	#
	# Delivery kinds
	#
	# Available kinds:
	# - email
	# - sms
	# - mailboxer
	#
	mattr_accessor :delivery_kinds
	@@delivery_kinds = [
		:email
#		:sms,
#		:mailboxer,
	]

	#
	# Mailer sender
	#
	mattr_accessor :mailer_sender
	#@@mailer_sender = ... to be set in module initializer

	#
	# Used SMS backend
	#
	# Available backends:
	# - plivo
	# - text_magic ... not implemented
	#
	mattr_accessor :sms_backend
	@@sms_backend = :plivo

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
