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

			# *****************************************************************
			# DIV merchant
			# *****************************************************************

			def self.thepay_div_merchant(payment, options = {})

				# Gate URL
				url = RicPaymentThepay::Backend::Config.gate_url
				
				# Optional data
				optional_data = {}
				optional_data["skin"] = options[:skin] if options[:skin]

				# Render CSS
				result = "";
				if options[:disable_button_css] != true
					skin = (options[:skin] ? "/#{options[:skin]}" : "")
					href = CGI.escapeHTML("#{url}div/style#{skin}/div.css?v=" + Time.now.to_i.to_s)
					result += "<link href=\"#{href}\" type=\"text/css\" rel=\"stylesheet\" />\n"
				end

				# Render handling script
				thepay_gate_url = url + "div/index.php?" + payment.query(join_string: "&amp;", optional_data: optional_data)
				result += "<script type=\"text/javascript\">"
				result += "\tvar thepayGateUrl = #{thepay_gate_url.to_json};\n"
				result += "\tvar disableThepayPopupCss = #{(options[:disable_popup_css] == true).to_json};\n"
				result += "</script>\n";

				# Include jquery
				src = CGI.escapeHTML("#{url}div/js/jquery.js?v=" + Time.now.to_i.to_s)
				result += "<script type=\"text/javascript\" src=\"#{src}\" async=\"async\"></script>\n"

				# Include DIV JS
				src = CGI.escapeHTML("#{url}div/js/div.js?v=" + Time.now.to_i.to_s)
				result += "<script type=\"text/javascript\" src=\"#{src}\" async=\"async\"></script>\n"

				result += "<div id=\"thepay-method-box\" style=\"border: 0;\"></div>\n"
				return result.html_safe
			end

			def thepay_div_merchant(payment, options = {})
				return MerchantHelper.thepay_div_merchant(payment, options)
			end

			# *****************************************************************
			# Radio merchant
			# *****************************************************************

			def self.thepay_radio_merchant(params, options = {})

				# Gate URL
				url = RicPaymentThepay::Backend::Config.gate_url

				# Args
				query_data = {}
				query_data["merchantId"] = RicPaymentThepay::Backend::Config.merchant_id
				query_data["accountId"] = RicPaymentThepay::Backend::Config.account_id
				query_data["name"] = options[:name] if options[:name]
				query_data["value"] = options[:value] if options[:value]
				query_data["showIcon"] = options[:show_icon] == false ? false : true
				query_data["selected"] = thepay_radio_merchant_check(params) ? params["tp_radio_value"].to_i : "" 
				query_data["currency"] = options[:currency] if options[:currency]

				# Render CSS
				result = ""
				href = CGI.escapeHTML("#{url}radiobuttons/style/radiobuttons.css?v=" + Time.now.to_i.to_s)
				result += "<link href=\"#{href}\" type=\"text/css\" rel=\"stylesheet\" />\n"

				# Render handling script
				thepay_gate_url = url + "radiobuttons/index.php?" + RicPaymentThepay::Backend::Query.build(query_data, join_string: "&amp;")
				result += "<script type=\"text/javascript\">"
				result += "\tvar thepayGateUrl = #{thepay_gate_url.to_json};\n"
				result += "\tvar thepayAppendCode = #{options[:append_code].to_json};\n" if options[:append_code]
				result += "</script>\n";

				# Include jquery
				src = CGI.escapeHTML("#{url}radiobuttons/js/jquery.js?v=" + Time.now.to_i.to_s)
				result += "<script type=\"text/javascript\" src=\"#{src}\" async=\"async\"></script>\n"

				# Include DIV JS
				src = CGI.escapeHTML("#{url}radiobuttons/js/radiobuttons.js?v=" + Time.now.to_i.to_s)
				result += "<script type=\"text/javascript\" src=\"#{src}\" async=\"async\"></script>\n"

				result += "<div id=\"thepay-method-box\" style=\"border: 0;\"></div>\n"
				return result.html_safe
			end

			def self.thepay_radio_merchant_check(params)
				return !params["tp_radio_value"].blank?
			end

			def self.thepay_radio_merchant_redirect_url(payment, params, options = {})

				# Get method ID
				method_id = nil
				method_id = params["tp_radio_value"] if thepay_radio_merchant_check(params)
				method_id = options[:forced_value] if options[:forced_value]

				# Check method ID
				if method_id.nil?
					return nil
				end

				# Set method ID to payment
				payment.method_id = method_id

				# Generate URL
				url = RicPaymentThepay::Backend::Config.gate_url + '?' + payment.query
				return url
			end

			def thepay_radio_merchant(params, options = {})
				return MerchantHelper.thepay_radio_merchant(params, options)
			end

			def thepay_radio_merchant_check(params)
				return MerchantHelper.thepay_radio_merchant_check(params)
			end

			def thepay_radio_merchant_redirect_url(payment, params, options = {})
				return MerchantHelper.thepay_radio_merchant_redirect_url(payment, params, options)
			end

		end
	end
end