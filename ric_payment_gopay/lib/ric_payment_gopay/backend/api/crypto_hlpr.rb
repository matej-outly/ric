#!/usr/bin/env ruby
# encoding: utf-8
#
# Created on Nov 23, 2012
#
# @author: Bedrich Hovorka
#

require 'digest/sha1'
require 'openssl'

# sifra se pouziva k symetrickemu podpisu (zasifrovani hashe - kratky plaintext)
CIPHER_ALGORITHM = 'des-ede3' # to by mel byt ecb mod

#
#    Pomocna trida pro sifrovani
#
class CryptoHlpr
  
    def toHex(x)
        list = []
        
        x.each_byte do |c|
            list << "%02x" % (c)
        end
        return list.join("")
    end

    def fromHex(hexStr)
        bytes = []
        hexStr = hexStr.split(" ").join('')
        0.step(hexStr.length, 2) do |i|
            bytes << hexStr.slice(i..i+1).to_i(16).chr
        end 
        return bytes.join('')
    end
    
    #
    # Vytvori hash ze zpravy
    # @param message zprava
    # @return SHA hash zpravy, HEX reprezentace
    #   
    def hash(message)
        return Digest::SHA1.hexdigest(message)
    end
    
    #
    # Desifrovani dat
    #
    # @param encryptedHEX
    # @param key
    # @return desifrovany retezec
    #
    def decrypt(encryptedHEX, key)
        raise ArgumentError, "" unless encryptedHEX != nil && key != nil      
        raise ArgumentError, "encryption key must have length at least 24" unless key.length >= 24
                 
        des = OpenSSL::Cipher::Cipher.new(CIPHER_ALGORITHM)
        des.decrypt
        des.key = key
        decrypted = des.update(fromHex(encryptedHEX))
        begin
            decrypted += des.final
        rescue OpenSSL::Cipher::CipherError
            # TODO
        end
        i = decrypted.index(0.chr)
        return decrypted.slice(0, i)
    end
    
    #
    # Sifrovani dat 3DES
    #
    # @param message
    # @param key
    # @return sifrovany obsah v HEX forme
    #
    def encrypt(message, key)
        raise ArgumentError, "" unless message != nil && key != nil
        raise ArgumentError, "encryption key must have length at least 24" unless key.length >= 24
  
        des = OpenSSL::Cipher::Cipher.new(CIPHER_ALGORITHM)
        des.encrypt
        des.key = key
        
        fullfill = 8 - (message.length%8)
        for i in 1..fullfill
            message += 0.chr
        end
        
        encrypted = des.update(message) + des.final
        return toHex(encrypted)
    end
end
