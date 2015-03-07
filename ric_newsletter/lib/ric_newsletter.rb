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

require "ric_newsletter/engine"

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
	# Newsletter model
	#
	mattr_accessor :newsletter_model
	def self.newsletter_model
		if @@newsletter_model.nil?
			return RicNewsletter::Newsletter
		else
			return @@newsletter_model.constantize
		end
	end

	#
	# Sent newsletter model
	#
	mattr_accessor :sent_newsletter_model
	def self.sent_newsletter_model
		if @@sent_newsletter_model.nil?
			return RicNewsletter::SentNewsletter
		else
			return @@sent_newsletter_model.constantize
		end
	end

	#
	# Sent newsletter customer model
	#
	mattr_accessor :sent_newsletter_customer_model
	def self.sent_newsletter_customer_model
		if @@sent_newsletter_customer_model.nil?
			return RicNewsletter::SentNewsletterCustomer
		else
			return @@sent_newsletter_customer_model.constantize
		end
	end

	#
	# Customer model
	#
	mattr_accessor :customer_model
	def self.customer_model
		if @@customer_model.nil?
			return RicCustomer::Customer
		else
			return @@customer_model.constantize
		end
	end

end
