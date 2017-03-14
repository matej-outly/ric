# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Structure
# *
# * Author: Matěj Outlý
# * Date  : 19. 1. 2017
# *
# *****************************************************************************

module RicWebsite
	module Concerns
		module Models
			module Structure extend ActiveSupport::Concern

				#
				# 'included do' causes the included code to be evaluated in the
				# context where it is included, rather than being executed in 
				# the module's context.
				#
				included do

					# *********************************************************
					# Structure
					# *********************************************************

					has_many :nodes, dependent: :nullify, class_name: RicWebsite.node_model.to_s
					has_many :fields, dependent: :destroy, class_name: RicWebsite.field_model.to_s

					# *********************************************************
					# Validators
					# *********************************************************

					validates_presence_of :name, :ref

					# *********************************************************
					# Nodes
					# *********************************************************

					after_save :synchronize_nested_nodes

				end

				module ClassMethods

					# *********************************************************
					# Columns
					# *********************************************************
					
					#
					# Get all columns permitted for editation
					#
					def permitted_columns
						[
							:model_class,
							:show_in_navigation,
							:ref,
							:name,
							:description,
							:icon,
							:is_navigable,
							:has_attachments,
							:has_pictures,
						]
					end

				end

				# *************************************************************
				# Include in URL
				# *************************************************************

				def include_in_url
					if @include_in_url.nil?
						@include_in_url = (self.fields.where(include_in_url: true).count > 0)
					end
					return @include_in_url 
				end

				# *************************************************************
				# Nodes
				# *************************************************************

				def synchronize_nested_nodes
					self.nodes.update_all(
						show_in_navigation: self.show_in_navigation,
						is_navigable: self.is_navigable,
						has_attachments: self.has_attachments,
					)
				end

			end
		end
	end
end