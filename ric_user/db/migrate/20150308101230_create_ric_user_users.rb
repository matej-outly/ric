class CreateRicUserUsers < ActiveRecord::Migration
	def change
		create_table :users do |t|

			# Timestamps
			t.timestamps null: true

			# *****************************************************************
			# Basic data, different devise plugins
			# *****************************************************************

			# Basic identification
			t.string :email, index: true

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
			t.datetime :locked_at, index: true

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
	end
end
