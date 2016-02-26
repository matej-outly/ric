# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Page block
# *
# * Author: Matěj Outlý
# * Date  : 16. 7. 2015
# *
# *****************************************************************************

module RicWebsite
	module Concerns
		module Models
			module PageBlock extend ActiveSupport::Concern

				#
				# 'included do' causes the included code to be evaluated in the
				# context where it is included, rather than being executed in 
				# the module's context.
				#
				included do
					
					# *********************************************************
					# Structure
					# *********************************************************

					#
					# Relation to page
					#
					belongs_to :page, class_name: RicWebsite.page_model.to_s

					#
					# Relation to common subject
					#
					belongs_to :subject, polymorphic: true

					#
					# Ordering
					#
					enable_ordering

					# *********************************************************
					# Validators
					# *********************************************************

					#
					# Page must be present
					#
					validates_presence_of :page_id

					# *********************************************************
					# Subject
					# *********************************************************

					#
					# Subject must be binded after create
					#
					before_create :bind_subject_before_create

					#
					# Subject must be synchronized after save
					#
					after_save :synchronize_subject_after_save

					# *********************************************************
					# Text virtual attributes
					# *********************************************************

					attr_writer :title
					attr_writer :content

				end

				module ClassMethods


				end

				# *************************************************************
				# Text virtual attributes
				# *************************************************************

				def title
					value = @title
					if value.nil? && self.subject
						value = self.subject.title
					end
					return value
				end

				def content
					value = @content
					if value.nil? && self.subject
						value = self.subject.content
					end
					return value
				end

				def content_formatted
					if self.subject
						return self.subject.content_formatted
					else
						return ""
					end
				end

			protected

				def bind_subject_before_create
					text = RicWebsite.text_model.new
					text.save
					self.subject = text
				end

				def synchronize_subject_after_save
					if self.subject
						self.subject.title = self.title
						self.subject.content = self.content
						self.subject.save
					end
				end

			end
		end
	end
end