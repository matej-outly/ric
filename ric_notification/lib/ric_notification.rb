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

# Engines
require "ric_notification/admin_engine"
require "ric_notification/public_engine"

# Models
require "ric_notification/concerns/models/notification"
require "ric_notification/concerns/models/notification_receiver"
require "ric_notification/concerns/models/notification_template"

# Services
require "ric_notification/concerns/services/notification"
require "ric_notification/concerns/services/delivery"
require "ric_notification/concerns/services/email_delivery"
require "ric_notification/concerns/services/inmail_delivery"

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
	include RicNotification::Concerns::Services::EmailDelivery
	include RicNotification::Concerns::Services::InmailDelivery

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
	# Mailer sender
	#
	mattr_accessor :mailer_sender
	#@@mailer_sender = ... to be set in module initializer

	#
	# Delivery methods
	#
	# Available methods:
	# - email
	# - inmail
	#
	mattr_accessor :delivery_methods
	@@delivery_methods = [
		:email
	]

end
