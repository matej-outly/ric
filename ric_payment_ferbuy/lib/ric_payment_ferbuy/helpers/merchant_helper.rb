# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Merchant helper
# *
# * Author: Matěj Outlý
# * Date  : 29. 6. 2016
# *
# *****************************************************************************

module RicPaymentFerbuy
	module Helpers
		module MerchantHelper

			def self.ferbuy_form(template, payment, options = {})

				# Gate URL
				url = RicPaymentFerbuy::Backend::Config.gate_url

				js = ""
				js += "function payment_ferbuy_submit_form(options)\n"
				js += "{\n"
				js += "	options['form'].submit();\n"
				js += "}\n"
				js += "var payment_ferbuy_timeout = null;\n"
				js += "function payment_ferbuy_set_timeout(callback, options)\n"
				js += "{\n"
				js += "	var timeout = options['timeout'] != null ? options['timeout'] : 0;\n"
				js += "	if (payment_ferbuy_timeout) {\n"
				js += "		clearTimeout(payment_ferbuy_timeout);\n"
				js += "	}\n"
				js += "	payment_ferbuy_timeout = setTimeout(function() { \n"
				js += "		callback(options);\n"
				js += "		payment_ferbuy_timeout = null;\n"
				js += "	}, timeout);\n"
				js += "}\n"
				js += "function payment_ferbuy_ready()\n"
				js += "{\n"
				js += "	if ($('.payment-ferbuy-form').length > 0) {\n"
				js += "		var timeout = parseInt($('.payment-ferbuy-form').data('timeout'));\n"
				js += "		payment_ferbuy_set_timeout(payment_ferbuy_submit_form, {\n"
				js += "			form: $('.payment-ferbuy-form'),\n"
				js += "			timeout: timeout,\n"
				js += "		});	\n"
				js += "	}\n"
				js += "}\n"
				js += "$(document).ready(payment_ferbuy_ready);\n"

				# Preset
				html = ""

				# Form
				html += template.form_tag(url, class: "payment-ferbuy-form", data: { timeout: options[:timeout] ? options[:timeout] : 0 }) do
					form_html = ""
					payment.query_data.each do |key, value|
						form_html += template.hidden_field_tag(key.to_sym, value)
					end
					if options[:submit] != false
						form_html += template.submit_tag(options[:label] ? options[:label] : I18n.t("helpers.submit.pay"))
					end
					form_html.html_safe
				end

				# JS
				html += template.javascript_tag(js)

				return html.html_safe
			end

			def ferbuy_form(payment, options = {})
				return MerchantHelper.ferbuy_form(self, payment, options)
			end

			def self.ferbuy_thepay_radio(template, options)
				
				html = ""

				html += "<div class=\"thepay-methods-radio-method thepay-methods-radio-method-ferbuy\">\n"
				html += "<input type=\"radio\" name=\"tp_radio_value\" id=\"tp_radio_ferbuy\" class=\"tp_radio_ferbuy\" value=\"ferbuy\">\n"
				html += "<label for=\"tp_radio_ferbuy\"><span class=\"thepay-methods-radio-name\">FerBuy</span>\n"
				html += "<img src=\"https://www.thepay.cz/gate/radiobuttons/style/icons/ferbuy.png\" width=\"86\" height=\"86\" alt=\"FerBuy\" class=\"thepay-methods-radio-icon\"></label>\n"
				html += "</div>\n"

				return html.html_safe
			end

			def ferbuy_thepay_radio(options = {})
				return MerchantHelper.ferbuy_thepay_radio(self, options)
			end

		end
	end
end