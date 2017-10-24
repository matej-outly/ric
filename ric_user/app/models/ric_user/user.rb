# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * User
# *
# * Author: Matěj Outlý
# * Date  : 9. 6. 2015
# *
# *****************************************************************************

module RicUser
	class User < ActiveRecord::Base
		include RicUser::Concerns::Models::User

		# *********************************************************************
		# Authentication
		# *********************************************************************

		if !(defined?(RicAuth).nil?)
			if RicAuth.use_devise
				include RicAuth::Concerns::Models::Devisable
			end
			if RicAuth.use_omniauth
				include RicAuth::Concerns::Models::Omniauthable
			end
		end
		
		# *********************************************************************
		# Roles
		# *********************************************************************
		
		if RicUser.user_role_association == :user_belongs_to_role
			if RicUser.use_static_roles
				include RicUser::Concerns::Models::User::SingleStaticRole
			else
				include RicUser::Concerns::Models::User::SingleDynamicRole
			end
		
		elsif RicUser.user_role_association == :user_has_and_belongs_to_many_roles
			if RicUser.use_static_roles
				include RicUser::Concerns::Models::User::MultiStaticRoles
			else
				include RicUser::Concerns::Models::User::MultiDynamicRoles
			end
		end

	end
end
