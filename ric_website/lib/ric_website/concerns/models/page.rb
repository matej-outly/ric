# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Page
# *
# * Author: Matěj Outlý
# * Date  : 16. 7. 2015
# *
# *****************************************************************************

module RicWebsite
	module Concerns
		module Models
			module Page extend ActiveSupport::Concern

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
					# Relation to menus
					#
					has_and_belongs_to_many :menus, class_name: RicWebsite.menu_model.to_s

					#
					# Relation to common model
					#
					belongs_to :model, polymorphic: true

					#
					# Ordering
					#
					enable_hierarchical_ordering

					#
					# Check model consistency before save
					#
					before_save :check_model_consistency

				end

				# *************************************************************
				# URL / Path
				# *************************************************************

				#
				# Generate path
				#
				def generate_url
					if !self.nature.blank?
						url_template = config(:natures, self.nature.to_sym, :url).to_s

						# Binded model
						if !self.model.nil?
							if self.model.respond_to?(:id)
								url_template = url_template.gsub(/:id/, self.model.id.to_s)
							end
							if self.model.respond_to?(:key)
								url_template = url_template.gsub(/:key/, self.model.key.to_s)
							end
						end

						# Store generated url
						self.url = url_template
					end
				end

				#
				# Check if page active in the given request
				#
				def active_url?
					return false
				end

				#
				# Compose path 
				#
				def path
					return self.url
				end

				# *************************************************************
				# Model
				# *************************************************************

				#
				# Check consistency of model polymorphic relation 
				#
				def check_model_consistency
					if !self.nature.blank?
						model_classname = config(:natures, self.nature.to_sym, :model)
					end
					if !model_classname.blank? && !self.model_id.blank?
						model_class = model_classname.constantize
						model = model_class.find_by_id(self.model_id)
						if !model.nil?
							self.model_type = model_classname
							return true
						end
					end
					self.model_id = nil
					self.model_type = nil
					return true
				end

				#
				# Get all available models
				#
				def available_models
					if !self.nature.blank?
						model_classname = config(:natures, self.nature.to_sym, :model)
					end
					if !model_classname.blank?
						model_class = model_classname.constantize
						return model_class.where(config(:natures, self.nature.to_sym, :filters)).order(id: :asc)
					else
						return []
					end
				end

			end
		end
	end
end