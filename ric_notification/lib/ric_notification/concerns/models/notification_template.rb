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

				included do

					# *********************************************************
					# Structure
					# *********************************************************

					has_many :notification_templates, class_name: RicNotification.notification_template_model.to_s, dependent: :nullify

					# *********************************************************
					# Validators
					# *********************************************************

					validates_presence_of :ref

					# *********************************************************
					# Ref
					# *********************************************************

					enum_column :ref, RicNotification.template_refs

				end

				module ClassMethods

					def permitted_columns
						[
							:subject,
							:message,
							:disabled,
							:dry
						]
					end
					
				end

			end
		end
	end
end