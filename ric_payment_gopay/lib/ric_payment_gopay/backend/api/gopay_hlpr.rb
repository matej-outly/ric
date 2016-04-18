#!/usr/bin/env ruby
# encoding: utf-8
#
# Created on Nov 23, 2012
#
# @author: Bedrich Hovorka
#

require_relative "crypto_hlpr"

CONCAT_DELIMITER = '|';

module PaymentStatus
    RESULT_CALL_COMPLETED = "CALL_COMPLETED"
    RESULT_CALL_FAILED = "CALL_FAILED"    
    
    STATE_CREATED = "CREATED"
    STATE_PAYMENT_METHOD_CHOSEN = "PAYMENT_METHOD_CHOSEN"
    STATE_AUTHORIZED = "AUTHORIZED"
    STATE_PAID = "PAID"
    STATE_CANCELED = "CANCELED"
    STATE_TIMEOUTED = "TIMEOUTED"
    STATE_REFUNDED = "REFUNDED"
    STATE_PARTIALLY_REFUNDED = "PARTIALLY_REFUNDED"
end

#
# Informacni element, ktery se pouziva pro informovani
# o stavu zpracovaní pozadavku. 
#
module PaymentResult    
    RES_ACCEPTED = "ACCEPTED"
    RES_FINISHED = "FINISHED"
    RES_FAILED = "FAILED"
end

module PaymentConstants

    # URL webove sluzby
    GOPAY_WS_ENDPOINT = "https://gate.gopay.cz/axis/EPaymentServiceV2?wsdl"
    
    #URL testovaci webove sluzby
    GOPAY_WS_ENDPOINT_TEST = "https://testgw.gopay.cz/axis/EPaymentServiceV2?wsdl"

    #URL testovaci platebni brany  -- uplna integrace
    GOPAY_FULL_TEST = "https://testgw.gopay.cz/gw/pay-full-v2"

    #URL platebni brany  -- uplna integrace 
    GOPAY_FULL = "https://gate.gopay.cz/gw/pay-full-v2"

    #URL vypisu plateb - testovaci brana
    GOPAY_ACCOUNT_STATEMENT = "https://testgw.gopay.cz/gw/services/get-account-statement"
   
    # Popis stavu platby - messages
    RETURN_URL_MESSAGES = {}
    ADDITIONAL_MESSAGES = {}
    
    RETURN_URL_MESSAGES[PaymentStatus::STATE_CREATED] = "Na platební bráně GoPay nebyla vybrána platební metoda. Pro dokončení platby pokračujte výběrem platební metody."
    RETURN_URL_MESSAGES[PaymentStatus::STATE_PAYMENT_METHOD_CHOSEN] = "Platba byla úspěšně založena."
    RETURN_URL_MESSAGES[PaymentStatus::STATE_CANCELED] = "Platba byla zrušena."
    RETURN_URL_MESSAGES[PaymentStatus::STATE_TIMEOUTED] = "Platba byla zrušena."
    RETURN_URL_MESSAGES[PaymentStatus::STATE_PAID] = "Platba byla úspěšně provedena."
    
    ADDITIONAL_MESSAGES["101"] = "Čekáme na dokončení online platby. O jejím provedení Vás budeme neprodleně informovat."
    ADDITIONAL_MESSAGES["102"] = "Instrukce pro dokončení platby Vám byly zaslány na emailovou adresu. O provedení platby Vás budeme budeme neprodleně informovat."
    
    def self.msgReturnUrl(key)
        return RETURN_URL_MESSAGES[key]
    end
    
    def self.addMessage(key)
        return ADDITIONAL_MESSAGES[key]
    end
end


#
# Pomocna trida pro platbu v systemu GoPay
# 
# - sestavovani retezcu pro podpis komunikacnich elementu
# - sifrovani/desifrovani retezcu
# - verifikace podpisu informacnich retezcu
# 
#
class GopayHlpr

    def initialize
        @cryptoHlpr = CryptoHlpr.new
    end
    
    def toStr(arg)          
        if isEmpty(arg)
            return ''
        elsif !!arg == arg
            if arg
                return '1'
            else 
                return '0'
            end
        # elsif isinstance(arg, date):
            # return date.isoformat()
        else
            return arg.to_s
        end
    end
    
    # Rozhoduje, zda je objekt "prazdny"
    # @param obj retezec
    # @return true je-li retezec prazdny (po odstraneni bilych znaku na zacatku i na konci) nebo null, jinak false
    #
    def isEmpty(obj)
        if obj == nil
            return true
        elsif obj.kind_of? String
            return obj.strip().length == 0
        else
            return false
        end
    end
           
    def concatArgs(*args)
        convertedArgs = args.collect{|x| toStr(x)}
        return convertedArgs.join(CONCAT_DELIMITER)
    end
    
    # v concatech je treba vyjmenovat kvuli kontrole ;)
    
    def concatPaymentCommand(paymentCommand, key)
        result = concatArgs(
                  paymentCommand.targetGoId, 
                  paymentCommand.productName, 
                  paymentCommand.totalPrice,
                  paymentCommand.currency, 
                  paymentCommand.orderNumber,
                  paymentCommand.failedURL, 
                  paymentCommand.successURL, 
                  paymentCommand.preAuthorization, 
                  paymentCommand.recurrentPayment, 
                  paymentCommand.recurrenceDateTo, 
                  paymentCommand.recurrenceCycle, 
                  paymentCommand.recurrencePeriod, 
                  paymentCommand.paymentChannels,
                  key)
        return result
    end
    
    #
    # Sestaveni retezce pro podpis vysledku stav platby.
    # 
    # @param paymentStatus     vysledek overeni stavu platby
    # @param key                 heslo subjektu pro komunikaci s GoPay
    # @return retezec pro podpis
    def concatPaymentStatus(paymentStatus, key)
        return concatArgs(
            paymentStatus.targetGoId,
            paymentStatus.productName,
            paymentStatus.totalPrice,
            paymentStatus.currency,
            paymentStatus.orderNumber,
            paymentStatus.recurrentPayment,
            paymentStatus.parentPaymentSessionId,
            paymentStatus.preAuthorization,
            paymentStatus.result,
            paymentStatus.sessionState,
            paymentStatus.sessionSubState,
            paymentStatus.paymentChannel,
            key);
    end
    
    #
    # Sestaveni retezce pro podpis popisu platby (paymentIdentity).
    # 
    # @param paymentIdentity     popis platby 
    # @param key                 heslo subjektu pro komunikaci s GoPay
    # @return retezec pro podpis
    #
    def concatPaymentIdentity(paymentIdentity, key)
        result = concatArgs(
            paymentIdentity.targetGoId,                
            paymentIdentity.paymentSessionId,
            paymentIdentity.parentPaymentSessionId,
            paymentIdentity.orderNumber,
            key);
        return result
    end
    
    #
    # Vrati carkou oddeleny seznam platebnich metod
    # @param paymentChannels jednotlive plateni metody 
    #
    def concatPaymentChannels(*paymentChannels)
        # if (paymentChannels is None or len(paymentChannels) < 1):
            # return None;
        return paymentChannels.join(", ")
    end
    
    #
    # Sestaveni retezce pro podpis sessionInfo.
    # 
    # @param paymentSession     objekt obsahujici data pro dotazani se na stav platby 
    # @param key                 heslo subjektu pro komunikaci s GoPay
    # @return retezec pro podpis
    #
    def concatPaymentSessionInfo(paymentSession, key)
        return concatArgs(paymentSession.targetGoId, paymentSession.paymentSessionId, key);
    end
    
    #
    # Sestaveni retezce pro podpis sessionInfo.
    # 
    # @param request     objekt obsahujici data pro vytvoreni nasledne platby
    # @param key         heslo subjektu pro komunikaci s GoPay
    # @return retezec pro podpis
    #
    def concatRecurrenceRequest(request, key)
        return concatArgs(request.parentPaymentSessionId, request.targetGoId, request.orderNumber, request.totalPrice, key);
    end
    
    #
    # Sestaveni retezce pro podpis sessionInfo.
    # 
    # @param request     objekt obsahujici data refundace
    # @param key         heslo subjektu pro komunikaci s GoPay
    # @return retezec pro podpis
    #
    def concatRefundRequest(request, key)
        return concatArgs(request.targetGoId, request.paymentSessionId, request.amount, request.currency, request.description, key);
    end
    
    #
    # Sestaveni retezce pro podpis paymentResult.
    # 
    # @param request     objekt obsahujici data vysleduku operace
    # @param key         heslo subjektu pro komunikaci s GoPay
    # @return retezec pro podpis
    #
    def concatPaymentResult(result, key)
        return concatArgs(result.paymentSessionId, result.result, key);
    end
   
    #
    # Sifrovani dat 3DES.
    #
    # @param data
    # @param key
    # @return sifrovany obsah v HEX forme
    #
    def encrypt(data, key)
        return @cryptoHlpr.encrypt(data, key);
    end 
    
    #
    # Desifrovani dat 3DES.
    #
    # @param data v HEX forme
    # @param key
    # @return desifrovany obsah
    #
    def decrypt(data, key)
        return @cryptoHlpr.decrypt(data, key);
    end   
    
    #
    # Vytvori hash ze zpravy.
    # 
    # @param data zprava
    # @return SHA hash zpravy, HEX reprezentace
    #
    def hash(data)
        return @cryptoHlpr.hash(data);
    end
    
    #
    # Podepsani 
    # @param data     data k podepsani
    # @param key      heslo subjektu pro komunikaci s GoPay 
    #
    def sign(obj, key)
        if obj.kind_of? ERemoteData
            className = obj.class.name
            methodName = "concat#{className.to_s.slice(1, className.length-1)}"
            concatResult = send methodName, obj, key
            h = hash(concatResult)
            obj.encryptedSignature = encrypt(h, key)
        else
            raise "Non-SOAP object can't have concat-method"
        end
    end
    
    def checkPaymentStatus(paymentStatus, goId, orderNumber, priceInCents, currency, productName, key)
        
        if paymentStatus.result != PaymentStatus::RESULT_CALL_COMPLETED
            raise "PS invalid call state state [" + paymentStatus.resultDescription.to_s + "]"
        end

        if !objEquals(orderNumber, paymentStatus.orderNumber)
            raise "PS invalid Order number orig[" + orderNumber.to_s + "] current[" + paymentStatus.orderNumber.to_s + "]"
        end

        if !objEquals(productName, paymentStatus.productName)
            raise "PS invalid product name orig[" + productName.to_s + "] current[" + paymentStatus.productName.to_s + "]"
        end

        if !objEquals(goId, paymentStatus.targetGoId)
            raise "PS invalid GoID orig[" + goId.to_s + "] current[" + paymentStatus.targetGoId.to_s + "]"
        end

        if !objEquals(priceInCents, paymentStatus.totalPrice)
            raise "PS invalid price orig[" + priceInCents.to_s + "] current[" + paymentStatus.totalPrice.to_s + "]"
        end
        
        if currency != nil and !objEquals(currency, paymentStatus.currency)
            raise "PS invalid currency orig[" + currency.to_s + "] current[" + paymentStatus.currency.to_s + "]"
        end
        
        hashedSignature = hash(concatPaymentStatus(paymentStatus, key))
        decryptedHash = decrypt(paymentStatus.encryptedSignature, key)

        if !objEquals(hashedSignature, decryptedHash)
            raise "PS invalid status signature"
        end

        return true
    end
    
    #
    # Kontrola parametru predavanych ve zpetnem volani po potvrzeni/zruseni platby - verifikace podpisu.
    # 
    # @param paymentIdentity        vracena navratova hodnota z platby 
    # @param goId                    identifikace eshopu nebo uzivatele
    # @param orderNumber            orderNumber vracene v redirectu
    # @param key                     heslo subjektu pro komunikaci s GoPay
    # 
    # @return true kdyz je vse OK
    #
    def checkPaymentIdentity(paymentIdentity, goId, orderNumber, key)
        if !objEquals(paymentIdentity.orderNumber, orderNumber)
            raise "PI invalid order number"
        end

        if !objEquals(paymentIdentity.targetGoId, goId)
            raise "PI invalid GoID"
        end

        hashedSignature = hash(concatPaymentIdentity(paymentIdentity, key))
        
        decryptedHash = decrypt(paymentIdentity.encryptedSignature, key)
        
        if !objEquals(hashedSignature, decryptedHash)
            raise "PI invalid signature"
        end
        return true
    end
    
    def checkPaymentResult(callReturn, paymentSessionId, key)
        hashedSignature = hash(concatPaymentResult(callReturn, key))
        
        if !objEquals(callReturn.paymentSessionId, paymentSessionId)
            raise "PI invalid paymentSessionId"
        end
        
        decryptedHash = decrypt(callReturn.encryptedSignature, key)
        
        if !objEquals(hashedSignature, decryptedHash)
            raise "PI invalid signature"
        end
        return true
    end

    #
    # Rozhoduje, zda jsou dva retezce shodne
    # @param str1 prvni retezec
    # @param str2 druhy retezec
    # @return vraci true pokud jsou oba retezce nenullove a shodne, jinak false
    #
    def objEquals(str1, str2)
        if str1 == nil || str2 == nil
            return False
        end
        result = str1.to_s == str2.to_s
        return result
    end    
end
        