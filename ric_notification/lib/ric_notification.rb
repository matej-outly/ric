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
require 'ric_notification/concerns/models/notification'
require 'ric_notification/concerns/models/notification_receiver'

# Mailers
require 'ric_notification/concerns/mailers/notification_mailer'

module RicNotification

	#
	# This will keep Rails Engine from generating all table prefixes with the engines name
	#
	def self.table_name_prefix
	end

	# *************************************************************************
	# Global functions
	# *************************************************************************

	#
	# Notify
	#
	def self.notify(message, receivers, options = {})
		RicNotification.notification_model.notify(message, receivers, options)
	end

	# *************************************************************************
	# Configuration
	# *************************************************************************

	#
	# Notification model
	#
	mattr_accessor :notification_model
	def self.notification_model
		if @@notification_model.nil?
			return RicNotification::Notification
		else
			return @@notification_model.constantize
		end
	end

	#
	# Notification receiver model
	#
	mattr_accessor :notification_receiver_model
	def self.notification_receiver_model
		if @@notification_receiver_model.nil?
			return RicNotification::NotificationReceiver
		else
			return @@notification_receiver_model.constantize
		end
	end

	#
	# User model
	#
	mattr_accessor :user_model
	def self.user_model
		if @@user_model.nil?
			return RicUser::User
		else
			return @@user_model.constantize
		end
	end

	#
	# Mailer sender
	#
	mattr_accessor :mailer_sender
	def self.mailer_sender
		if @@mailer_sender.nil?
			return "no-reply@clockstar.cz"
		else
			return @@mailer_sender
		end
	end

end
