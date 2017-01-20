# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Node helper
# *
# * Author: Matěj Outlý
# * Date  : 22. 7. 2015
# *
# *****************************************************************************

module RicWebsite
	module Helpers
		module NodeHelper

			def node_field_row(form, field)
				result = ""
				if field.kind == "belongs_to"
					if field.ref.ends_with?("_id")
						result = form.token_input_row(field.ref, ric_website_admin.search_nodes_path, as: field.ref[0..-4], value_attr: :id, label_attr: :navigation_name, limit: 1, label: field.name)
					else
						result = form.token_input_row(field.ref, ric_website_admin.search_nodes_path, as: field.ref, value_attr: :id, label_attr: :navigation_name, limit: 1, label: field.name)
					end
				elsif field.kind == "enum"
					# TODO
				else
					result = form.generic_row(field.ref, field.kind, label: field.name)
				end
				return result
			end

		end
	end
end
