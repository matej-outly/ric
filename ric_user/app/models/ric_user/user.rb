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
		
		if RicUser.user_person_association == :none
			include RicUser::Concerns::Models::SingleRoleUser
		
		elsif RicUser.user_person_association == :one_user_one_person
			include RicUser::Concerns::Models::SingleRoleUser
			include RicUser::Concerns::Models::SinglePersonUser
		
		elsif RicUser.user_person_association == :one_user_many_people
			include RicUser::Concerns::Models::MultiRolesUser
			include RicUser::Concerns::Models::MultiPeopleUser

		elsif RicUser.user_person_association == :many_users_one_person
			include RicUser::Concerns::Models::SingleRoleUser
			include RicUser::Concerns::Models::SinglePersonUser

		end
			
	end
end
