#!/usr/bin/env ruby
# encoding: utf-8
#
# Created on Nov 23, 2012
#
# @author: Bedrich Hovorka
#

class ERemoteData
    def initialize(attrs = {}, *args)
        super(*args)
        attrs.each do |k, v|
            if ! k.match(/^@(xsi|xmlns|soapenv)/)
                self.send "#{camelize(k.to_s)}=", sanitizeValue(v)
            end
        end
    end
    
    def sanitizeValue(value) 
        if value.is_a?(Hash)
            return nil
        else
            return value
        end
    end
  
    def to_map
        result = {}
        
        instance_variables.each do |v|
            name = "#{v.to_s.sub('@','')}"
            value = send name
            if value.kind_of? ERemoteData
                result[name] = value.to_map
            else
                result[name] = value
            end  
        end
        
        return result
    end
    
    def uncapitalize(str)
        str[0, 1].downcase + str[1..-1]
    end

    def camelize(str)
        return str if str !~ /_/ && str =~ /[A-Z]+.*/
       
        parts = str.split('_').map{|e| e.capitalize}
        parts[0] = uncapitalize(parts[0])
        return parts.join
    end
end

class EPaymentCommand < ERemoteData
    attr_accessor :targetGoId,
                  :partnerGoId,
                  
                  :productName,
                  :orderNumber,
                  
                  :totalPrice,  
                  :currency,
                  
                  :customerData,
                  
                  :successURL,
                  :failedURL,
                  
                  :preAuthorization,
                  
                  :recurrentPayment,
                  :recurrenceCycle,
                  :recurrencePeriod,
                  :recurrenceDateTo,    
                  
                  :paymentChannels,
                  :defaultPaymentChannel,
                  
                  :p1,
                  :p2,
                  :p3,
                  :p4,
                  
                  :lang,
                  
                  :encryptedSignature
end

class ECustomerData < ERemoteData
    attr_accessor :firstName,
                  :lastName,
                  
                  :city,
                  :street,
                  :postalCode,
                  :countryCode,
                  
                  :email,
                  :phoneNumber
end

class EPaymentStatus < ERemoteData
    attr_accessor :paymentSessionId,
                  :parentPaymentSessionId,
                  
                  :sessionState,
                  
                  :sessionSubState,
                  :sessionSubStateDesc,
                  
                  :productName,
                  :targetGoId,
                  :orderNumber,
                  :totalPrice,
                  :currency,  
                  :preAuthorization,
                  :recurrentPayment,
                  
                  :paymentChannel,
                    
                  :p1,
                  :p2,
                  :p3,
                  :p4,
                  
                  :result,
                  :resultDescription,
                
                  :encryptedSignature
end

class EPaymentSessionInfo < ERemoteData
    attr_accessor :paymentSessionId,
                  :targetGoId,
                  :encryptedSignature
end

class EPaymentIdentity < ERemoteData
    attr_accessor :paymentSessionId,
                  :orderNumber,
                  :parentPaymentSessionId,
                  :targetGoId,
                  :p1,
                  :p2,
                  :p3,
                  :p4,
                  :encryptedSignature
end

class EPaymentResult < ERemoteData
    attr_accessor :paymentSessionId,
                  :result,
                  :resultDescription,
                  :encryptedSignature
end

class ERecurrenceRequest < ERemoteData
    attr_accessor :parentPaymentSessionId,
                  :targetGoId,
                  :orderNumber,
                  :totalPrice,
                  :encryptedSignature
end

class ERefundRequest < ERemoteData
    attr_accessor :paymentSessionId,
                  :targetGoId,
                  :amount,
                  :currency,
                  :description,
                  :encryptedSignature
end
