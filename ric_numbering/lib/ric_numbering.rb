# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * RicNumbering
# *
# * Author: Matěj Outlý
# * Date  : 3. 11. 2017
# *
# *****************************************************************************

# Engines
require "ric_numbering/engine"

# Models
require "ric_numbering/concerns/models/sequence"
require "ric_numbering/concerns/models/numbered"

module RicNumbering

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
	# Sequence model
	#
	mattr_accessor :sequence_model
	def self.sequence_model
		return @@sequence_model.constantize
	end
	@@sequence_model = "RicNumbering::Sequence"

	#
	# Sequence refs
	#
	mattr_accessor :sequence_refs
	@@sequence_refs = nil

	#
	# Sequence formats
	#
	mattr_accessor :sequence_formats
	@@sequence_formats = nil

end
