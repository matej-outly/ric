# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Message
# *
# * Author: Matěj Outlý
# * Date  : 19. 2. 2017
# *
# *****************************************************************************

module RicInmail
	module Concerns
		module Models
			module Message extend ActiveSupport::Concern

				#
				# 'included do' causes the included code to be evaluated in the
				# context where it is included, rather than being executed in 
				# the module's context.
				#
				included do
					
					# *********************************************************************
					# Structure
					# *********************************************************************

					belongs_to :owner, class_name: RicMagazine.user_model.to_s
					belongs_to :sender, class_name: RicMagazine.user_model.to_s
					#belongs_to :receiver, class_name: RicMagazine.user_model.to_s

					# *********************************************************************
					# Folder
					# *********************************************************************

					enum_column :folder, [:inbox, :outbox, :archive, :drafts]

					# *********************************************************************
					# Delivery state
					# *********************************************************************

					state_column :delivery_state, [:created, :sent, :received], default: :created

				end

			end
		end
	end
end