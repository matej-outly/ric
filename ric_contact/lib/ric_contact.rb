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
require 'ric_contact/concerns/models/branch'
require 'ric_contact/concerns/models/contact_message'
require 'ric_contact/concerns/models/contact_person'

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
	# Enable contact messages subsystem
	#
	mattr_accessor :enable_contact_messages
	@@enable_contact_messages = false

	#
	# Contact message model
	#
	mattr_accessor :contact_message_model
	def self.contact_message_model
		return @@contact_message_model.constantize
	end
	@@contact_message_model = "RicContact::ContactMessage"

	#
	# Enable contact people subsystem
	#
	mattr_accessor :enable_contact_people
	@@enable_contact_people = false

	#
	# Contact person model
	#
	mattr_accessor :contact_person_model
	def self.contact_person_model
		return @@contact_person_model.constantize
	end
	@@contact_person_model = "RicContact::ContactPerson"

	#
	# Localization of some specific columns (roles, descriptions, etc.)
	#
	mattr_accessor :localization
	@@localization = false

end
