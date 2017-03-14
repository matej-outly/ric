# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Node attachments
# *
# * Author: Matěj Outlý
# * Date  : 19. 1. 2017
# *
# *****************************************************************************

module RicWebsite
	module Concerns
		module Controllers
			module Admin
				module NodeAttachmentsController extend ActiveSupport::Concern
					
					#
					# 'included do' causes the included code to be evaluated in the
					# context where it is included, rather than being executed in 
					# the module's context.
					#
					included do
						
						layout "ruth_admin_modal"

						before_action :set_node
						before_action :set_node_attachment, only: [:show, :update, :destroy]
					
					end

					def index
					end

					def show
						render json: @node_attachment.to_json(methods: :attachment_url)
					end

					def create
						@node_attachment = RicWebsite.node_attachment_model.new(node_attachment_params)
						@node_attachment.node_id = @node.id
						if @node_attachment.save
							render json: @node_attachment.id
						else
							render json: @node_attachment.errors
						end
					end

					def update
						if @node_attachment.update(node_attachment_params)
							render json: @node_attachment.id
						else
							render json: @node_attachment.errors
						end
					end

					def destroy
						@node_attachment.destroy
						render json: @node_attachment.id
					end

				protected

					# *************************************************************************
					# Model setters
					# *************************************************************************

					def set_node_attachment
						@node_attachment = RicWebsite.node_attachment_model.find_by_id(params[:id])
						if @node_attachment.nil? || @node_attachment.node_id != @node.id
							redirect_to nodes_path, alert: I18n.t("activerecord.errors.models.#{RicWebsite.node_attachment_model.model_name.i18n_key}.not_found")
						end
					end

					def set_node
						@node = RicWebsite.node_model.find_by_id(params[:node_id])
						if @node.nil?
							redirect_to nodes_path, alert: I18n.t("activerecord.errors.models.#{RicWebsite.node_model.model_name.i18n_key}.not_found")
						end
					end

					# *************************************************************************
					# Param filters
					# *************************************************************************

					def node_attachment_params
						params.require(:node_attachment).permit(RicWebsite.node_attachment_model.permitted_columns)
					end

				end
			end
		end
	end
end
