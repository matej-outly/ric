# *****************************************************************************
# *
# * Devisable user
# *
# * Author: Matěj Outlý
# * Date  : 28. 4. 2017
# *
# *****************************************************************************

module RicAuth
	module Concerns
		module Models
			module Devisable extend ActiveSupport::Concern

				included do

					devise *(RicAuth.devise_features.map { |feature| feature.to_sym })
					
					# *********************************************************
					# Locking & confirmation
					# *********************************************************
					
					define_method :active_for_authentication? do
						return false if self.class.confirmable? && !confirmed?
						return false if locked?
						return true
					end

					define_method :inactive_message do
						return :unconfirmed if self.class.confirmable? && !confirmed?
						return :inactive # if locked?
					end

				end

				module ClassMethods

					# *********************************************************
					# Features
					# *********************************************************

					def database_authenticatable?
						RicAuth.devise_features.include?(:database_authenticatable)
					end

					def recoverable?
						RicAuth.devise_features.include?(:recoverable)
					end

					def rememberable?
						RicAuth.devise_features.include?(:rememberable)
					end

					def trackable?
						RicAuth.devise_features.include?(:trackable)
					end

					def validatable?
						RicAuth.devise_features.include?(:validatable)
					end

					def registerable?
						RicAuth.devise_features.include?(:registerable)
					end

					def confirmable?
						RicAuth.devise_features.include?(:confirmable)
					end

					def lockable?
						RicAuth.devise_features.include?(:lockable)
					end

					def timeoutable?
						RicAuth.devise_features.include?(:timeoutable)
					end

					def omniauthable?
						RicAuth.devise_features.include?(:omniauthable)
					end

				end

				# *************************************************************
				# Locking
				# *************************************************************

				def locked?
					return !self.locked_at.nil?	
				end

				def lock
					self.locked_at = Time.current
					self.save
				end

				def unlock
					self.locked_at = nil
					self.save
				end

			end
		end
	end
end