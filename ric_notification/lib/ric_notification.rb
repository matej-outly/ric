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
require "ric_notification/concerns/models/notification_delivery"
require "ric_notification/concerns/models/notification_receiver"
require "ric_notification/concerns/models/notification_template"

# Services
require "ric_notification/concerns/services/notification"
require "ric_notification/concerns/services/delivery"
require "ric_notification/concerns/services/email_delivery"
require "ric_notification/concerns/services/sms_delivery"
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
	include RicNotification::Concerns::Services::SmsDelivery
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
	# Mailer sender
	#
	mattr_accessor :mailer_sender
	#@@mailer_sender = ... to be set in module initializer

	#
	# Delivery kinds
	#
	# Available kinds:
	# - email
	# - sms
	# - inmail
	#
	mattr_accessor :delivery_kinds
	@@delivery_kinds = [
		:email
#		:sms,
#		:inmail,
	]

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

end
