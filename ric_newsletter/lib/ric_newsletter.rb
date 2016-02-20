# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * RicNewsletter
# *
# * Author: Matěj Outlý
# * Date  : 16. 2. 2015
# *
# *****************************************************************************

# Engines
require "ric_newsletter/admin_engine"
require "ric_newsletter/public_engine"

# Models
require 'ric_newsletter/concerns/models/customer'
require 'ric_newsletter/concerns/models/newsletter'
require 'ric_newsletter/concerns/models/sent_newsletter'
require 'ric_newsletter/concerns/models/sent_newsletter_customer'

# Mailers
require 'ric_newsletter/concerns/mailers/newsletter_mailer'

module RicNewsletter

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
	# Newsletter model
	#
	mattr_accessor :newsletter_model
	def self.newsletter_model
		return @@newsletter_model.constantize
	end
	@@newsletter_model = "RicNewsletter::Newsletter"

	#
	# Sent newsletter model
	#
	mattr_accessor :sent_newsletter_model
	def self.sent_newsletter_model
		return @@sent_newsletter_model.constantize
	end
	@@sent_newsletter_model = "RicNewsletter::SentNewsletter"

	#
	# Sent newsletter customer model
	#
	mattr_accessor :sent_newsletter_customer_model
	def self.sent_newsletter_customer_model
		return @@sent_newsletter_customer_model.constantize
	end
	@@sent_newsletter_customer_model = "RicNewsletter::SentNewsletterCustomer"

	#
	# Customer model
	#
	mattr_accessor :customer_model
	def self.customer_model
		return @@customer_model.constantize
	end
	@@customer_model = "RicCustomer::Customer"

	#
	# Mailer sender
	#
	mattr_accessor :mailer_sender
	@@mailer_sender = "no-reply@clockapp.cz"

end
