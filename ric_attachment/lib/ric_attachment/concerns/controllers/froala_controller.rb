# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Froala editor interface
# *
# * Author: Matěj Outlý
# * Date  : 9. 10. 2017
# *
# *****************************************************************************

module RicAttachment
	module Concerns
		module Controllers
			module FroalaController extend ActiveSupport::Concern

				included do
				
					#before_action :set_attachment, only: [:show, :create, :update, :destroy]

				end

			end
		end
	end
end
