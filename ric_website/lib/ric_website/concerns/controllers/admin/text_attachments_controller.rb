# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Text attachments
# *
# * Author: Matěj Outlý
# * Date  : 17. 7. 2015
# *
# *****************************************************************************

module RicWebsite
	module Concerns
		module Controllers
			module Admin
				module TextAttachmentsController extend ActiveSupport::Concern

					#
					# 'included do' causes the included code to be evaluated in the
					# context where it is included, rather than being executed in 
					# the module's context.
					#
					included do
					
						#
						# Set text before some actions
						#
						before_action :set_text_attachment, only: [:destroy]

					end

					#
					# Links action
					#
					def links
						result = []
						
						# Pages
						@pages = RicWebsite.page_model.all.order(lft: :asc)
						@pages.each do |page|
							result << { title: I18n.t("general.page").upcase_first + " - " + page.name, value: page.url }
						end

						# Text attachments
						@text_attachments = RicWebsite.text_attachment_model.all.order(id: :asc)
						@text_attachments.each do |text_attachment|
							if text_attachment.file.exists?
								result << { title: I18n.t("general.file").upcase_first + " - " + text_attachment.file_file_name, value: text_attachment.file.url }
							end
						end
						
						render json: result
					end

					#
					# Images action
					#
					def images
						result = []
						@text_attachments = RicWebsite.text_attachment_model.where(kind: "image").order(id: :asc)
						@text_attachments.each do |text_attachment|
							if text_attachment.file.exists?
								result << { title: I18n.t("general.file").upcase_first + " - " + text_attachment.file_file_name, value: text_attachment.file.url }
							end
						end
						render json: result
					end

					#
					# Create action
					#
					def create
						@text_attachment = RicWebsite.text_attachment_model.new(text_attachment_params)
						if @text_attachment.save
							render json: @text_attachment.id
						else
							render json: @text_attachment.errors
						end
					end

					#
					# Destroy action
					#
					def destroy
						@text_attachment.destroy
						render json: @text_attachment.id
					end

				protected

					def set_text_attachment
						@text_attachment = RicWebsite.text_attachment_model.find_by_id(params[:id])
						if @text_attachment.nil?
							render json: false
						end
					end

					# 
					# Never trust parameters from the scary internet, only allow the white list through.
					#
					def text_attachment_params
						params.require(:text_attachment).permit(:file)
					end

				end
			end
		end
	end
end
