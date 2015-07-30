# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Journal messages
# *
# * Author: Matěj Outlý
# * Date  : 30. 6. 2015
# *
# *****************************************************************************

module RicJournal
	module Concerns
		module Controllers
			module Public
				module JournalMessagesController extend ActiveSupport::Concern

					#
					# 'included do' causes the included code to be evaluated in the
					# context where it is included, rather than being executed in 
					# the module's context.
					#
					included do

						#
						# Set newie before some actions
						#
						before_action :set_newie, only: [:show]

					end

					#
					# Index action
					#
					def index
						@newies = RicJournal.newie_model.published.order(published_at: :desc).page(params[:page]).per(50)
					end

					#
					# Show action
					#
					def show
					end

				protected

					def set_newie
						@newie = RicJournal.newie_model.find_by_id(params[:id])
						if @newie.nil?
							redirect_to newies_path, alert: I18n.t("activerecord.errors.models.#{RicJournal.newie_model.model_name.i18n_key}.not_found")
						end
					end

				end
			end
		end
	end
end
