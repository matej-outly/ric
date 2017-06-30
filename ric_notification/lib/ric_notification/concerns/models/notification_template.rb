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

					validates_presence_of :ref

					# *********************************************************
					# Ref
					# *********************************************************

					enum_column :ref, RicNotification.template_refs
					
				end

			end
		end
	end
end