# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Nodes
# *
# * Author: Matěj Outlý
# * Date  : 19. 1. 2017
# *
# *****************************************************************************

module RicWebsite
	module Concerns
		module Controllers
			module Admin
				module NodesController extend ActiveSupport::Concern

					#
					# 'included do' causes the included code to be evaluated in the
					# context where it is included, rather than being executed in 
					# the module's context.
					#
					included do
						
						before_action :set_node, only: [:show, :edit, :update, :move, :generate_slugs, :destroy]

					end

					def index
					end

					def tree
						render json: RicWebsite.node_model.to_hierarchical_json
					end

					def lazy_tree
						node = RicWebsite.node_model.find_by_id(params[:node]) if params[:node]
						nodes = (node ? node.children : RicWebsite.node_model.roots)
						result = nodes.as_json(methods: :url_original)
						nodes.each_with_index do |node, index|
							result[index]["load_on_demand"] = (node.lft + 1 < node.rgt)
						end
						render json: ActiveSupport::JSON.encode(result)
					end

					def search
						@nodes = RicWebsite.node_model.search(params[:q]).order(name: :asc)
						render json: @nodes.to_json
					end

					def new
						@node = RicWebsite.node_model.new
						@node.structure_id = params[:structure_id] if params[:structure_id]
						@node.parent_id = params[:parent_id] if params[:parent_id]
					end

					def edit
					end

					def create
						@node = Node.new(node_params)
						@node.disable_slug_generator
						if @node.save
							respond_to do |format|
								format.html { redirect_to edit_node_path(@node), notice: I18n.t("activerecord.notices.models.#{RicWebsite.node_model.model_name.i18n_key}.create") }
								format.json { render json: @node.id }
							end
						else
							respond_to do |format|
								format.html { render "new" }
								format.json { render json: @node.errors }
							end
						end
					end

					def update
						new_node_params = node_params
						if @requested_structure_id
							requested_structure = RicWebsite.structure_model.find_by_id(@requested_structure_id)
							if requested_structure
								@node.change_structure(requested_structure)
								respond_to do |format|
									format.html { redirect_to main_app.edit_admin_node_path(@node), notice: I18n.t("activerecord.notices.models.#{RicWebsite.node_model.model_name.i18n_key}.update") }
									format.json { render json: @node.id }
								end
							else
								respond_to do |format|
									format.html { render "edit" }
									format.json { render json: @node.errors }
								end
							end
						else 
							@node.disable_slug_generator
							if @node.update(new_node_params)
								respond_to do |format|
									format.html { redirect_to edit_node_path(@node), notice: I18n.t("activerecord.notices.models.#{RicWebsite.node_model.model_name.i18n_key}.update") }
									format.json { render json: @node.id }
								end
							else
								respond_to do |format|
									format.html { render "edit" }
									format.json { render json: @node.errors }
								end
							end
						end
					end

					def move
						if RicWebsite.node_model.move(params[:id], params[:relation], params[:destination_id])
							respond_to do |format|
								format.html { redirect_to request.referrer, notice: I18n.t("activerecord.notices.models.#{RicWebsite.node_model.model_name.i18n_key}.move") }
								format.json { render json: @node.id }
							end
						else
							respond_to do |format|
								format.html { redirect_to request.referrer, alert: I18n.t("activerecord.errors.models.#{RicWebsite.node_model.model_name.i18n_key}.move") }
								format.json { render json: @node.errors }
							end
						end
					end

					def generate_slugs
						@node.generate_slugs
						respond_to do |format|
							format.html { redirect_to request.referrer, notice: I18n.t("activerecord.notices.models.#{RicWebsite.node_model.model_name.i18n_key}.generate_slugs") }
							format.json { render json: @node.id }
						end
					end

					def destroy
						@node.destroy
						if @node.parent_id
							return_path = edit_node_path(@node.parent_id)
						else
							return_path = nodes_path
						end
						respond_to do |format|
							format.html { redirect_to return_path, notice: I18n.t("activerecord.notices.models.#{RicWebsite.node_model.model_name.i18n_key}.destroy") }
							format.json { render json: @node.id }
						end
					end

				protected

					# *************************************************************************
					# Model setters
					# *************************************************************************

					def set_node
						@node = RicWebsite.node_model.find_by_id(params[:id])
						if @node.nil?
							redirect_to nodes_path, alert: I18n.t("activerecord.errors.models.#{RicWebsite.node_model.model_name.i18n_key}.not_found")
						end
					end

					# *************************************************************************
					# Param filters
					# *************************************************************************

					def node_params
						result = nil
						if @node
							result = params.require(:node).permit(@node.permitted_columns)
						else
							result = params.require(:node).permit(:name, :parent_id, :structure_id)
						end
						if @node && result[:structure_id]
							if result[:structure_id].to_i != @node.structure_id # Request to change structure
								@requested_structure_id = result[:structure_id].to_i
							end
							result[:structure_id] = @node.structure_id
						end
						return result
					end

				end
			end
		end
	end
end
