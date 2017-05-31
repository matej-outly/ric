# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Abstract engine controller
# *
# * Author: Matěj Outlý
# * Date  : 10. 12. 2014
# *
# *****************************************************************************

module RicAuth
	class Mailer < Devise::Mailer
		include Devise::Controllers::UrlHelpers
		
		def confirmation_instructions(record, token, opts = {})
			RicNotification.notify([:user_confirmation, record, ric_auth.confirmation_url(confirmation_token: token)], record) if !(defined?(RicNotification).nil?)
		end

		def reset_password_instructions(record, token, opts = {})
			RicNotification.notify([:user_reset_password, record, ric_auth.edit_password_url(reset_password_token: token)], record) if !(defined?(RicNotification).nil?)
		end

		def unlock_instructions(record, token, opts = {})
			RicNotification.notify([:user_unlock, record, ric_auth.unlock_url(unlock_token: token)], record) if !(defined?(RicNotification).nil?)
		end

		def password_change(record, opts = {})
			RicNotification.notify([:user_new_password, record, ""], record) if !(defined?(RicNotification).nil?)
		end

	end
end
