# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Organization relation
# *
# * Author: Matěj Outlý
# * Date  : 31. 7. 2017
# *
# *****************************************************************************

module RicOrganization
	module Concerns
		module Models
			module OrganizationRelation extend ActiveSupport::Concern

				included do
					
					# *********************************************************
					# Structure
					# *********************************************************

					belongs_to :actor, class_name: RicOrganization.organization_model.to_s
					belongs_to :actee, class_name: RicOrganization.organization_model.to_s

					# *********************************************************
					# Validators
					# *********************************************************

					validates_presence_of :actor_id, :actee_id, :kind

					# *********************************************************
					# Kind
					# *********************************************************

					enum_column :kind, RicOrganization.relation_kinds.keys

					# *********************************************************
					# Partner
					# *********************************************************

					# Attributes for human usage
					attr_reader :current_organization_id
					attr_accessor :partner_organization_id
					attr_accessor :partner_kind

					# Unfold all available actors and actees
					enum_column :partner_kind, RicOrganization.relation_kinds.values.map { |i| i.values }.flatten

					before_validation :convert_partnership_to_relationship

				end

				module ClassMethods

					# *********************************************************
					# Columns
					# *********************************************************

					def permitted_columns
						result = [
							:current_organization_id,
							:partner_organization_id,
							:partner_kind,
						]
						return result
					end

				end

				# *************************************************************
				# Partner
				# *************************************************************

				def current_organization_id=(value)
					@current_organization_id = value
					
					# Convert
					convert_relationship_to_partnership

					# Clear cache
					@current_organization = nil
					@partner_organization = nil
				end

				def current_organization
					@current_organization = RicOrganization.organization_model.find_by_id(current_organization_id) if @current_organization.nil?
					return @current_organization
				end

				def partner_organization
					@partner_organization = RicOrganization.organization_model.find_by_id(partner_organization_id) if @partner_organization.nil?
					return @partner_organization
				end

			protected

				def convert_relationship_to_partnership
					if !self.actor_id.blank? && !self.actee_id.blank? && !self.kind.blank?
						spec = RicOrganization.relation_kinds[self.kind.to_sym]
						if self.current_organization_id == self.actor_id
							self.partner_organization_id = self.actee_id
							self.partner_kind = spec[:actee]
						elsif self.current_organization_id == self.actee_id
							self.partner_organization_id = self.actor_id
							self.partner_kind = spec[:actor]
						end
					end
				end

				def convert_partnership_to_relationship
					if !self.current_organization_id.blank? && !self.partner_organization_id.blank? && !self.partner_kind.blank?
						RicOrganization.relation_kinds.each do |kind, spec|
							if spec[:actor].to_s == self.partner_kind.to_s
								self.actor_id = self.partner_organization_id
								self.actee_id = self.current_organization_id
								self.kind = kind
								break
							elsif spec[:actee].to_s == self.partner_kind.to_s
								self.actee_id = self.partner_organization_id
								self.actor_id = self.current_organization_id
								self.kind = kind
								break
							end
						end
					end
				end

			end
		end
	end
end