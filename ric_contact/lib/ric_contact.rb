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
	# Branch model
	#
	mattr_accessor :branch_model
	def self.branch_model
		if @@branch_model.nil?
			return RicContact::Branch
		else
			return @@branch_model.constantize
		end
	end

	#
	# Contact message model
	#
	mattr_accessor :contact_message_model
	def self.contact_message_model
		if @@contact_message_model.nil?
			return RicContact::ContactMessage
		else
			return @@contact_message_model.constantize
		end
	end

end
