# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Customer data - customer
# *
# * Author: Matěj Outlý
# * Date  : 9. 5. 2016
# *
# *****************************************************************************

module RicPaymentThepay
	class Backend
		module CustomerData
			class Customer

				#
				# First name.
				#
				attr_accessor :first_name

				#
				# Last name.
				#
				attr_accessor :last_name

				#
				# Address (street + number).
				#
				attr_accessor :address

				#
				# Postal code (zipcode).
				#
				attr_accessor :postal_code

				#
				# City.
				#
				attr_accessor :city

				#
				# E-mail.
				#
				attr_accessor :email

				#
				# Mobile phone.
				#
				attr_accessor :mobile_phone

				#
				# Constructor
				#
				def initialize(data = {})
					self.first_name = data[:first_name] if !data[:first_name].nil?
					self.last_name = data[:last_name] if !data[:last_name].nil?
					self.address = data[:address] if !data[:address].nil?
					self.postal_code = data[:postal_code] if !data[:postal_code].nil?
					self.city = data[:city] if !data[:city].nil?
					self.email = data[:email] if !data[:email].nil?
					self.mobile_phone = data[:mobile_phone] if !data[:mobile_phone].nil?
				end

			end
		end
	end
end