# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Notification template
# *
# * Author: Matěj Outlý
# * Date  : 9. 5. 2016
# *
# *****************************************************************************

module RicNotification
	module Concerns
		module Models
			module NotificationTemplate extend ActiveSupport::Concern

				#
				# 'included do' causes the included code to be evaluated in the
				# context where it is included, rather than being executed in 
				# the module's context.
				#
				included do

					# *********************************************************
					# Validators
					# *********************************************************

					validates_presence_of :key

					# *********************************************************
					# Keys
					# *********************************************************

					if config(:keys)
						enum_column :key, config(:keys)
					end
					
				end

				module ClassMethods

					# *********************************************************
					# Scopes
					# *********************************************************

				end

			end
		end
	end
end