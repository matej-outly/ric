class CreateRicUserUsers < ActiveRecord::Migration
	def change
		create_table :users do |t|

			# Timestamps
			t.timestamps null: true

			# Basic identification
			t.string :email

			# Authentication
			t.string :encrypted_password, null: false, default: ""

			# Recoverable
			t.string   :reset_password_token
			t.datetime :reset_password_sent_at

			# Rememberable
			t.datetime :remember_created_at

			# Trackable
			t.integer  :sign_in_count, default: 0, null: false
			t.datetime :current_sign_in_at
			t.datetime :last_sign_in_at
			t.inet     :current_sign_in_ip
			t.inet     :last_sign_in_ip

			# Confirmable
			# t.string   :confirmation_token
			# t.datetime :confirmed_at
			# t.datetime :confirmation_sent_at
			# t.string   :unconfirmed_email # Only if using reconfirmable

			# Lockable
			# t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
			# t.string   :unlock_token # Only if unlock strategy is :email or :both
			
			# Lockable by admin
			t.datetime :locked_at

			# Name
			t.string :name_firstname
			t.string :name_lastname

			# Authorization
			t.string :role

			# Person
			t.integer :person_id
			t.string :person_type

		end
		RicUser::User.create(name_firstname: "", name_lastname: "", email: "admin@clockstar.cz", password: "admin", password_confirmation: "admin", role: "admin")
	end
end
