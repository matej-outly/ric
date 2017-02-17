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
			RicNotification.notify([:user_confirmation, record, confirmation_url(record, confirmation_token: token)], record) if !(defined?(RicNotification).nil?)
		end

		def reset_password_instructions(record, token, opts = {})
			RicNotification.notify([:user_reset_password, record, edit_password_url(record, reset_password_token: token)], record) if !(defined?(RicNotification).nil?)
		end

		def unlock_instructions(record, token, opts = {})
			RicNotification.notify([:user_unlock, record, unlock_url(record, unlock_token: token)], record) if !(defined?(RicNotification).nil?)
		end

		def password_change(record, opts = {})
			RicNotification.notify([:user_new_password, record, ""], record) if !(defined?(RicNotification).nil?)
		end

	end
end
