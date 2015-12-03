# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Banner
# *
# * Author: Matěj Outlý
# * Date  : 10. 12. 2014
# *
# *****************************************************************************

module RicAdvert
	module Concerns
		module Models
			module Banner extend ActiveSupport::Concern

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
					# Relation to advertiser
					#
					belongs_to :advertiser, class_name: RicAdvert.advertiser_model.to_s

					#
					# Relation to statistics
					#
					has_many :banner_statistics, class_name: RicAdvert.banner_statistic_model.to_s

					# *********************************************************
					# Validators
					# *********************************************************

					#
					# Form/to consistency
					# 
					validate :validate_from_to_consistency

					#
					# Kind must be present
					#
					validates_presence_of :kind

					# *********************************************************
					# File
					# *********************************************************

					#
					# Attachment
					#
					has_attached_file :file
					validates_attachment_content_type :file, :content_type => /\A.*\Z/

					#
					# Resolve file kind before save
					#
					before_save :resolve_file_kind

					#
					# Available file kinds
					#
					enum_column :file_kind, ["image", "flash"]

					#
					# Add file url method to json
					#
					add_methods_to_json :file_url

					# *********************************************************
					# Kind
					# *********************************************************

					#
					# Kind
					#
					enum_column :kind, config(:kinds)

				end

				module ClassMethods

					# *********************************************************
					# Scopes
					# *********************************************************

					#
					# Scope for valid banners
					#
					def valid(date)
						where("(valid_from <= :date OR valid_from IS NULL) AND (:date < valid_to OR valid_to IS NULL)", date: date)
					end

					#
					# Scope for invalid banners
					#
					def already_invalid(date)
						where("valid_to <= :date", date: date)
					end

					#
					# Scope for invalid banners
					#
					def sofar_invalid(date)
						where(":date < valid_from", date: date)
					end

					# *********************************************************
					# Search mechanism
					# *********************************************************

					#
					# Find random banner of given kind valid for given date
					#
					def random(kind, date)
						valid_banners = valid(date).where(kind: kind).order(priority: :asc)
						if !valid_banners.empty?
							random_banner = valid_banners[Random.rand(valid_banners.size)]
						else
							return nil
						end
					end

				end

				# *************************************************************
				# Statistics
				# *************************************************************
				
				#
				# Banner is clicked
				#
				def clicked(ip)
					banner_statistic = find_or_create_statistic(ip)
					banner_statistic.clicks += 1
					banner_statistic.save
					return true
				end

				#
				# Banner is impressed
				#
				def impressed(ip)
					banner_statistic = find_or_create_statistic(ip)
					banner_statistic.impressions += 1
					banner_statistic.save
					return true
				end

				def impressions
					return RicAdvert.banner_statistic_model.where(banner_id: self.id).sum(:impressions)
				end

				def clicks
					return RicAdvert.banner_statistic_model.where(banner_id: self.id).sum(:clicks)
				end

				# *************************************************************
				# File
				# *************************************************************

				#
				# Get URL of image original
				#
				def file_url
					if file.exists?
						return file.url(:original)
					else
						return nil
					end
				end

			protected

				#
				# Find existing or create new banner statistic record associated to the banner with ginen IP
				#
				def find_or_create_statistic(ip)
					banner_statistic = RicAdvert.banner_statistic_model.where(banner_id: self.id, ip: ip).first
					if banner_statistic.nil?
						banner_statistic = RicAdvert.banner_statistic_model.new(banner_id: self.id, ip: ip)
						banner_statistic.save
					end
					return banner_statistic
				end

				#
				# "valid_from" must be before "valid_to" (causality)
				#
				def validate_from_to_consistency

					if self.valid_from.nil? || self.valid_to.nil?
						return
					end

					# Causality
					if self.valid_from >= self.valid_to
						errors.add(:to, I18n.t('activerecord.errors.models.banner.attributes.valid_to.before_valid_from'))
					end

				end

				#
				# Resolve file kind
				#
				def resolve_file_kind
					if self.file_content_type
						if self.file_content_type.start_with?("image/")
							self.file_kind = "image"
						elsif self.file_content_type == "application/x-shockwave-flash"
							self.file_kind = "flash"
						else
							self.file_kind = nil
						end
					end
				end

			end
		end
	end
end