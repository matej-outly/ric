# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * RicOrganization
# *
# * Author: Matěj Outlý
# * Date  : 31. 7. 2017
# *
# *****************************************************************************

# Engines
require "ric_organization/engine"

# Models
require "ric_organization/concerns/models/organization"
require "ric_organization/concerns/models/organization_assignment"
require "ric_organization/concerns/models/organization_relation"
require "ric_organization/concerns/models/user_assignment"

module RicOrganization

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
	# Organization model
	#
	mattr_accessor :organization_model
	def self.organization_model
		return @@organization_model.constantize
	end
	@@organization_model = "RicOrganization::Organization"

	#
	# Organization relation model
	#
	mattr_accessor :organization_relation_model
	def self.organization_relation_model
		return @@organization_relation_model.constantize
	end
	@@organization_relation_model = "RicOrganization::OrganizationRelation"

	#
	# Organization assignment model
	#
	mattr_accessor :organization_assignment_model
	def self.organization_assignment_model
		return @@organization_assignment_model.constantize
	end
	@@organization_assignment_model = "RicOrganization::OrganizationAssignment"

	#
	# User assignment model
	#
	mattr_accessor :user_assignment_model
	def self.user_assignment_model
		return @@user_assignment_model.constantize
	end
	@@user_assignment_model = "RicOrganization::UserAssignment"

	#
	# User model
	#
	mattr_accessor :user_model
	def self.user_model
		return @@user_model.constantize
	end
	@@user_model = "RicUser::User"

	#
	# Available relation kinds
	#
	mattr_accessor :relation_kinds
	@@relation_kinds = []

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
