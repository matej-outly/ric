class CreateRicUserRelations < ActiveRecord::Migration
	def change
		# *********************************************************************
		# Authorization
		# *********************************************************************

		if RicUser.user_role_association == :user_belongs_to_role

			if RicUser.use_static_roles
				# Single-role authorization, static roles - Uncomment this line for single-role authorization
				add_column :users, :role, :string
			else
				# Single-role authorization, dynamic roles - Uncomment this line for single-role authorization
				add_column :users, :role_id, :integer
				add_index :users, :role_id
			end

		elsif RicUser.user_role_association == :user_has_and_belongs_to_many_roles

			if RicUser.use_static_roles
				# Multi-role authorization, static roles - Uncomment this table for multi-role authorization
				create_table :user_roles do |t|
					t.timestamps null: true
					t.integer :user_id, index: true
					t.string :role
				end
			else
				# Multi-role authorization, dymanic roles - Uncomment this table for multi-role authorization
				create_table :user_roles do |t|
					t.timestamps null: true
					t.integer :user_id, index: true
					t.integer :role_id, index: true
				end
			end

		end

		# *********************************************************************
		# Binded people
		# *********************************************************************

		if RicUser.user_person_association == :one_user_one_person || RicUser.user_person_association == :many_users_one_person
			# Single-person relation - Uncomment this line for single-person relation
			add_column :users, :person_id, :integer
			add_index :users, :person_id
			add_column :users, :person_type, :string
			add_index :users, :person_type
		elsif RicUser.user_person_association == :one_user_many_people
			# Multi-people relation - Uncomment this table for multi-people relation
			create_table :user_people do |t|
				t.timestamps null: true
				t.integer :user_id, index: true
				t.integer :person_id, index: true
				t.string :person_type, index: true
			end
		end 
		
		# *********************************************************************
		# Initial data
		# *********************************************************************
		
		user = RicUser::User.create(name_firstname: "", name_lastname: "", email: "admin@clockstar.cz", password: "admin", password_confirmation: "admin")
		
		if RicUser.user_role_association == :user_belongs_to_role
			if RicUser.use_static_roles
				user.role = "admin"
				user.save
			else
				admin_role = RicUser::Role.create(name: "Administrátor", ref: "admin")
				user.role_id = admin_role.id
				user.save
			end
		elsif RicUser.user_role_association == :user_has_and_belongs_to_many_roles
			if RicUser.use_static_roles
				user.roles = ["admin"]
			else
				admin_role = RicUser::Role.create(name: "Administrátor", ref: "admin")
				user.role_ids = [admin_role.id]
				user.save
			end
		end

	end
end
