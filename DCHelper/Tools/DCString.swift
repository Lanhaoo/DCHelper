//
//  DCString.swift
//  DCHelper
//
//  Created by Laura Torres on 2023/11/29.
//

import Foundation
import CommonCrypto

public extension String{
    
    func extractNumbers() -> String {
        let digits = filter { $0.isNumber }
        return String(digits)
    }
    
    func subString(to index: Int) -> String {
        return StringProcessing.subString(to: index, self)
    }
    
    var isBlank: Bool {
        let trimmed = trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty
    }
    
    var isValidCountryCode:Bool{
        return self.hasPrefix("52")
    }
    
    var phoneNumber:Self{
        if self.count == 12{
            if isValidCountryCode{
                let startIndex = self.index(self.startIndex, offsetBy: 2)
                let resultString = String(self[startIndex...])
                return resultString
            }
        }
        return self
    }
    
    var phoneNumberValidity:(isValid:Bool,phoneNumber:String){
        if self.count == 10 || self.count == 12{
            if self.count == 10{
                return (true,self)
            }else if self.count == 12{
                return (self.isValidCountryCode,phoneNumber)
            }else{
                return (false,"")
            }
        }
        return (false,"")
    }
    
    var toIntValue : Int {
        get{
            guard let num = NumberFormatter().number(from: self) else { return 0 }
            return num.intValue
        }
    }
    
    var toDoubleValue : Double {
        get{
            guard let num = NumberFormatter().number(from: self) else { return 0 }
            return num.doubleValue
        }
    }
    
    var commaFormatted:Self{
        get{
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.groupingSeparator = ","
            let number = self.toIntValue
            let formattedString = formatter.string(from: NSNumber(value: number))
            return formattedString ?? ""
        }
    }
    
    var generateRandomPhoneNumberString : Self {
        let length = 10
        let allowedChars = "0123456789"
        var randomString = ""
        for _ in 0..<length {
            let randomIndex = Int.random(in: 0..<allowedChars.count)
            let character = allowedChars[allowedChars.index(allowedChars.startIndex, offsetBy: randomIndex)]
            randomString.append(character)
        }
        return randomString
    }
}


struct StringProcessing {
    
    static func numbers(_ text:String) -> String {
        let digits = text.filter { $0.isNumber }
        return String(digits)
    }
    
    
    static func subString(to index: Int,_ text:String) -> String {
        if text.count > index {
            let endIndex = text.index(text.startIndex, offsetBy: index)
            let subString = text[..<endIndex]
            return String(subString)
        } else {
            return text
        }
    }
    
    static func generateNowTimeInterval()->String{
        let currentDate = Date()
        let timeInterval = currentDate.timeIntervalSince1970
        let millisecond = Int(round(timeInterval * 1000))
        return String(millisecond)
    }
    
    static func generateRandomString()->String{
        let letters = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        func randomString(length: Int) -> String {
            var randomString = ""
            for _ in 0..<length {
                let randomIndex = Int.random(in: 0..<letters.count)
                randomString += String(letters[letters.index(letters.startIndex, offsetBy: randomIndex)])
            }
            return randomString
        }
        return randomString(length: 16)
    }
    
    static func md5Hash(text:String) -> String {
        if let data = text.data(using: .utf8) {
            var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
            _ = data.withUnsafeBytes { body in
                CC_MD5(body.baseAddress, CC_LONG(data.count), &digest)
            }
            let md5String = digest.map { String(format: "%02hhx", $0) }.joined()
            return md5String
        }
        return ""
    }
}

