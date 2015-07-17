# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * RicWebsite
# *
# * Author: Matěj Outlý
# * Date  : 13. 5. 2015
# *
# *****************************************************************************

# Engines
require "ric_website/admin_engine"
require "ric_website/public_engine"

# Models
require 'ric_website/concerns/models/page'
require 'ric_website/concerns/models/menu'
require 'ric_website/concerns/models/text'
require 'ric_website/concerns/models/text_attachment'

module RicWebsite

	#
	# This will keep Rails Engine from generating all table prefixes with the engines name
	#
	def self.table_name_prefix
	end

	# *************************************************************************
	# Configuration
	# *************************************************************************

	#
	# Text model
	#
	mattr_accessor :text_model
	def self.text_model
		if @@text_model.nil?
			return RicWebsite::Text
		else
			return @@text_model.constantize
		end
	end

	#
	# Text attachment model
	#
	mattr_accessor :text_attachment_model
	def self.text_attachment_model
		if @@text_attachment_model.nil?
			return RicWebsite::TextAttachment
		else
			return @@text_attachment_model.constantize
		end
	end

	#
	# Page model
	#
	mattr_accessor :page_model
	def self.page_model
		if @@page_model.nil?
			return RicWebsite::Page
		else
			return @@page_model.constantize
		end
	end

	#
	# Menu model
	#
	mattr_accessor :menu_model
	def self.menu_model
		if @@menu_model.nil?
			return RicWebsite::Menu
		else
			return @@menu_model.constantize
		end
	end

end
