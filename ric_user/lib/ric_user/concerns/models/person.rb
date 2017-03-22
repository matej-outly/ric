# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Person
# *
# * Author: Matěj Outlý
# * Date  : 20. 3. 2017
# *
# *****************************************************************************

module RicUser
	module Concerns
		module Models
			module Person extend ActiveSupport::Concern

				def person_role
					raise "Please define person role."
				end
				
				def person_synchronized_attrs
					[]
				end

				def synchronized_params
					result = {}
					self.person_synchronized_attrs.each do |attribute|
						result[attribute.to_sym] = self.send(attribute.to_sym)
					end
					return result
				end

			end
		end
	end
end