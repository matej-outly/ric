# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * People selector
# *
# * Author: Matěj Outlý
# * Date  : 11. 4. 2017
# *
# *****************************************************************************

module RicUser
	class PeopleSelector < ActiveRecord::Base
		include RicUser::Concerns::Models::PeopleSelector

		# Define selector
#		define_selector :selector_ref, {
#
#			# Select function - DB query selecting valid people expected to be returned
#			select: lambda { |params|
#				SomePerson.where(some_param: params[:some_param])
#			},
#			
#			# Search function - [ {some_param: value, ...}, {some_param: value, ...}, ... ] defining valid selector params expected to be returned
#			search: lambda { |query|
#				SomePerson.where("(lower(unaccent(name_lastname)) LIKE ('%' || lower(unaccent(trim(:query))) || '%'))", query: query).map { |person| { some_param: person.some_param } }
#			},
#			
#			# Selector title - title uniquely identifying selector with given params expected to be returned
#			title: lambda { |params|
#				"Some title for #{SomePerson.find_by(some_param: params[:some_param])}"
#			}
#
#		}

	end
end
