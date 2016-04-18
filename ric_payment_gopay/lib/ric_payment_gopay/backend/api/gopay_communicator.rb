#!/usr/bin/env ruby
# encoding: utf-8
#
# Created on Nov 23, 2012
#
# @author: Bedrich Hovorka
#

require 'savon'
require_relative "types"

PATH_TO_SSL_CERTIFICATES = "/etc/ssl/certs/ca-certificates.crt"

#
# Pomocna trida pro platbu v systemu GoPay
# 
# - zapoudreni volani vzdalenych metod (Bridge)
# 
#
class GopayCommunicator

    # pro savon je treba uvadet ?wsdl
    def initialize(url)
        # nejjednodussi vytvoreni:
        @client = Savon.client(url)
        
        # bez overovani certifikatu (na vlastni NEBEZPECI tj. pouze pro test!):
        # @client = Savon::Client.new do |wsdl, http|
            # http.auth.ssl.verify_mode = :none
            # wsdl.document = url
        # end
    end
    
    def createPayment(request)
        paymentReturn = @client.request :createPayment do
            soap.body = {v1: request.to_map}
        end
        return EPaymentStatus.new(paymentReturn.to_hash[:create_payment_response][:create_payment_return])
    end
    
    def paymentStatus(request)
        paymentReturn = @client.request :paymentStatus do
            soap.body = {v1: request.to_map}
        end
        return EPaymentStatus.new(paymentReturn.to_hash[:payment_status_response][:payment_status_return])
    end
    
    def voidRecurrentPayment(request)
        paymentReturn = @client.request :voidRecurrentPayment do
            soap.body = {v1: request.to_map}
        end
        return EPaymentResult.new(paymentReturn.to_hash[:void_recurrent_payment_response][:void_recurrent_payment_return])
    end
    
    def capturePayment(request)
        paymentReturn = @client.request :capturePayment do
            soap.body = {v1: request.to_map}
        end
        return EPaymentResult.new(paymentReturn.to_hash[:capture_payment_response][:capture_payment_return])
    end
    
    def voidAuthorization(request)
        paymentReturn = @client.request :voidAuthorization do
            soap.body = {v1: request.to_map}
        end
        return EPaymentResult.new(paymentReturn.to_hash[:void_authorization_response][:void_authorization_return])
    end
    
    def createRecurrentPayment(request)
        paymentReturn = @client.request :createRecurrentPayment do
            soap.body = {v1: request.to_map}
        end
        return EPaymentStatus.new(paymentReturn.to_hash[:create_recurrent_payment_response][:create_recurrent_payment_return])
    end
    
    def refundPayment(request)
        paymentReturn = @client.request :refundPayment do
            soap.body = {v1: request.to_map}
        end
        return EPaymentResult.new(paymentReturn.to_hash[:refund_payment_response][:refund_payment_return])
    end
end
        