# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Newsletter
# *
# * Author: Matěj Outlý
# * Date  : 16. 2. 2015
# *
# *****************************************************************************

module RicNewsletter
	module Concerns
		module Models
			module Newsletter extend ActiveSupport::Concern

				#
				# 'included do' causes the included code to be evaluated in the
				# context where it is included, rather than being executed in 
				# the module's context.
				#
				included do
					
					# *********************************************************************
					# Structure
					# *********************************************************************

					#
					# Relation to sent newsletters
					#
					has_many :sent_newsletters, class_name: RicNewsletter.sent_newsletter_model.to_s

				end

				module ClassMethods

				end

				def identifying_name
					return I18n.l(self.created_at) + " - " + self.subject
				end

			end
		end
	end
end