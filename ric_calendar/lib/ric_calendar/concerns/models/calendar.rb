# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Calendar
# *
# * Author: Jaroslav Mlejnek, Matěj Outlý
# * Date  : 19. 2. 2017
# *
# *****************************************************************************

module RicCalendar
	module Concerns
		module Models
			module Calendar extend ActiveSupport::Concern

				included do

					# *********************************************************
					# Structure
					# *********************************************************

					belongs_to :resource, polymorphic: true
					has_many :events, class_name: RicCalendar.event_model.to_s, dependent: :destroy

					# *********************************************************
					# Kind
					# *********************************************************

					# Validators
					validates_presence_of :kind
					validate :validate_resource_id_based_on_kind

					# Callbacks
					before_save :set_resource_type_based_on_kind
					after_save :set_resource_id_based_on_kind # ID must be known at this time

					# Enum
					enum_column :kind, config(:kinds).keys

				end

				module ClassMethods

					# *********************************************************
					# Columns
					# *********************************************************

					#
					# Get all columns permitted for editation
					#
					def permitted_columns
						result = []
						result = result.concat(self.permitted_columns_for_colored)
						result = result.concat([
							:name,
							:kind,
							:resource_id
						])
						return result
					end

					# *********************************************************
					# Queries
					# *********************************************************

					#
					# Get only calendars, which are not in black list
					#
					def not_disabled(disabled_calendars)
						if disabled_calendars == nil
							all
						else
							where.not(id: disabled_calendars)
						end
					end

				end

				#
				# Load events for this calendar
				#
				def resource_events
					if @resource_events.nil?
						if self.resource
							@resource_events = self.resource.send(self.kind_options[:resource_to_events_attr])
						else
							@resource_events = self.kind_options[:event_type].constantize.all
						end
					end
					return @resource_events
				end

				# *************************************************************
				# Kind
				# *************************************************************

				def kind_options
					if @kind_options.nil?
						kinds = config(:kinds)
						if kinds && kinds[self.kind.to_sym]
							@kind_options = kinds[self.kind.to_sym]
						end
					end
					return @kind_options
				end

			protected

				#
				# Resource ID must be filled if resource type is defined in config and is different than "self" calendar
				#
				def validate_resource_id_based_on_kind
					if self.kind && self.kind_options[:resource_type] && self.kind_options[:resource_type] != self.class.name
						if self.resource_id.blank?
							errors.add(:resource_id, I18n.t("activerecord.errors.models.#{self.class.model_name.i18n_key}.attributes.resource_id.blank"))
						end
					end
				end

				#
				# Simply set resource type from config to correctly represent relation to resource
				#
				def set_resource_type_based_on_kind
					if self.kind
						self.resource_type = self.kind_options[:resource_type]
					end
				end

				#
				# If resource type is "self" calendar, resource ID is derived from ID and calendar points to itself
				#
				def set_resource_id_based_on_kind
					if self.kind
						if self.resource_type == self.class.name && self.resource_id != self.id
							self.resource_id = self.id # Point to itself
							self.save
						end
					end
				end

			end
		end
	end
end