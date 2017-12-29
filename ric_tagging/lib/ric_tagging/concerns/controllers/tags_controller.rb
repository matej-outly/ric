# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Tags
# *
# * Author: Matěj Outlý
# * Date  : 28. 12. 2017
# *
# *****************************************************************************

module RicTagging
	module Concerns
		module Controllers
			module TagsController extend ActiveSupport::Concern

				included do
					
					before_action :set_tag, only: [:update, :destroy]

				end
				
				def search
					@tags = RicTagging.tag_model.search(params[:q]).order(name: :asc)
					render json: @tags.to_json
				end

				def create
					@tag = RicTagging.tag_model.new(tag_params)
					if @tag.save
						respond_to do |format|
							format.html { redirect_to request.referrer, notice: RicTagging.tag_model.human_notice_message(:create) }
							format.json { render json: @tag.id }
						end
					else
						respond_to do |format|
							format.html { redirect_to request.referrer, alert: RicTagging.tag_model.human_error_message(:create) }
							format.json { render json: @tag.errors }
						end
					end
				end

				def update
					if @tag.update(tag_params)
						respond_to do |format|
							format.html { redirect_to request.referrer, notice: RicTagging.tag_model.human_notice_message(:update) }
							format.json { render json: @tag.id }
						end
					else
						respond_to do |format|
							format.html { redirect_to request.referrer, alert: RicTagging.tag_model.human_error_message(:update) }
							format.json { render json: @tag.errors }
						end
					end
				end

				def destroy
					@tag.destroy
					respond_to do |format|
						format.html { redirect_to request.referrer, notice: RicTagging.tag_model.human_notice_message(:destroy) }
						format.json { render json: @tag.id }
					end
				end

			protected
				
				def set_tag
					@tag = RicTagging.tag_model.find_by_id(params[:id])
					not_found if @tag.nil?
				end

				def tag_params
					params.require(RicTagging.tag_model.model_name.param_key).permit(RicTagging.tag_model.permitted_columns)
				end

			end
		end
	end
end
