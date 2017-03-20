class CreateRicUserUsers < ActiveRecord::Migration
	def change
		create_table :users do |t|

			# Timestamps
			t.timestamps null: true

			# *****************************************************************
			# Basic data, different devise plugins
			# *****************************************************************

			# Basic identification
			t.string :email

			# Authentication
			t.string :encrypted_password, null: false, default: ""

			# Recoverable - Uncomment for recoverable feature
			t.string   :reset_password_token
			t.datetime :reset_password_sent_at

			# Rememberable - Uncomment for rememberable feature
			t.datetime :remember_created_at

			# Trackable - Uncomment for trackable feature
			t.integer  :sign_in_count, default: 0, null: false
			t.datetime :current_sign_in_at
			t.datetime :last_sign_in_at
			t.inet     :current_sign_in_ip
			t.inet     :last_sign_in_ip

			# Confirmable - Uncomment for confirmable feature
			#t.string   :confirmation_token
			#t.datetime :confirmed_at
			#t.datetime :confirmation_sent_at
			#t.string   :unconfirmed_email # Only if using reconfirmable

			# Lockable - Uncomment for lockable feature
			#t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
			#t.string   :unlock_token # Only if unlock strategy is :email or :both
			
			# Lockable by admin
			t.datetime :locked_at

			# *****************************************************************
			# Fancy data
			# *****************************************************************

			# Name
			t.string :name_firstname
			t.string :name_lastname

			# Avatar
			t.attachment :avatar
			t.integer :avatar_crop_x
			t.integer :avatar_crop_y
			t.integer :avatar_crop_w
			t.integer :avatar_crop_h

		end

		# *********************************************************************
		# Authorization
		# *********************************************************************

		# Multi-role authorization - Uncomment this table for multi-role authorization
		#create_table :user_roles do |t|
		#	t.timestamps null: true
		#	t.integer :user_id, index: true
		#	t.string :role
		#end

		# Single-role authorization - Uncomment this line for single-role authorization
		#add_column :users, :role, :string

		# *********************************************************************
		# Binded people
		# *********************************************************************

		# Multi-people relation - Uncomment this table for multi-people relation
		#create_table :user_people do |t|
		#	t.timestamps null: true
		#	t.integer :user_id, index: true
		#	t.integer :person_id, index: true
		#	t.string :person_type, index: true
		#end

		# Single-person relation - Uncomment this line for single-person relation
		#add_column :users, :person_id, :integer
		#add_index :users, :person_id
		#add_column :users, :person_type, :string
		#add_index :users, :person_type

		# *********************************************************************
		# Initial data
		# *********************************************************************
		
		user = RicUser::User.create(name_firstname: "", name_lastname: "", email: "admin@clockstar.cz", password: "admin", password_confirmation: "admin")
		
		# Single-role authorization
		#user.role = "admin"
		#user.save

		# Multi-role authoriation
		#user.roles = ["admin"]

	end
end
