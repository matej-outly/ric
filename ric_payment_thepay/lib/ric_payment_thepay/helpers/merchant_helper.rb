# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * DIV merchant helper
# *
# * Author: Matěj Outlý
# * Date  : 31. 3. 2016
# *
# *****************************************************************************

module RicPaymentThepay
	module Helpers
		module MerchantHelper

			def self.thepay_div_merchant(payment, options = {})

				# Gate URL
				url = RicPaymentThepay::Backend::Config.gate_url
				
				# Optional args
				query_data = {}
				query_data["skin"] = options[:skin] if options[:skin]

				result = "";
				if options[:disable_button_css] != true
					skin = (options[:skin] ? "/#{options[:skin]}" : "")
					href = CGI.escapeHTML("#{url}div/style#{skin}/div.css?v=" + Time.now.to_i.to_s)
					result += "<link href=\"#{href}\" type=\"text/css\" rel=\"stylesheet\" />\n"
				end

				thepay_gate_url = url + "div/index.php?" + payment.query(query_data)
				result += "<script type=\"text/javascript\">"
				result += "\tvar thepayGateUrl = #{thepay_gate_url.to_json};\n"
				result += "\tvar disableThepayPopupCss = #{(options[:disable_popup_css] == true).to_json};\n"
				result += "</script>\n";

				src = CGI.escapeHTML("#{url}div/js/jquery.js?v=" + Time.now.to_i.to_s)
				result += "<script type=\"text/javascript\" src=\"#{src}\" async=\"async\"></script>\n"

				src = CGI.escapeHTML("#{url}div/js/div.js?v=" + Time.now.to_i.to_s)
				result += "<script type=\"text/javascript\" src=\"#{src}\" async=\"async\"></script>\n"

				result += "<div id=\"thepay-method-box\" style=\"border: 0;\"></div>\n"
				return result.html_safe
			end

			def thepay_div_merchant(payment, options = {})
				return MerchantHelper.thepay_div_merchant(payment, options)
			end

		end
	end
end