# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * RicPerson
# *
# * Author: Matěj Outlý
# * Date  : 9. 6. 2015
# *
# *****************************************************************************

# Engine
require "ric_person/engine"

# Models
require "ric_person/concerns/models/person"
require "ric_person/concerns/models/people_selector"
require "ric_person/concerns/models/people_selectable"

module RicPerson

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
	# User model
	#
	mattr_accessor :user_model
	def self.user_model
		return @@user_model.constantize
	end
	@@user_model = "RicUser::User"

	#
	# People Selector model
	#
	mattr_accessor :people_selector_model
	def self.people_selector_model
		return @@people_selector_model.constantize
	end
	@@people_selector_model = "RicPerson::PeopleSelector"

	#
	# Available person types
	#
	mattr_accessor :person_types
	@@person_types = []

end
