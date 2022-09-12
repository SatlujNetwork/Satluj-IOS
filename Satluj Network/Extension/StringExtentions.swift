//
//  StringExtentions.swift
//  Satluj Network
//
//  Created by Brahma Naidu on 03/04/22.
//

import Foundation
import UIKit
extension String {
    
    
    
    var htmlToAttributedString: NSAttributedString? {
        let modifiedFont = "<span style=\"font-family: OpenSans; font-size: \(14.0)\">\(self)</span>"
        
       // String(format:"<span style=\"font-family: '-apple-system', 'OpenSans'; font-size: \(14.0)\">%@</span>", self)

        guard let data = modifiedFont.data(using: .utf8) else { return nil }
            do {
                return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
            } catch {
                return nil
            }
        }
        var htmlToString: String {
            return htmlToAttributedString?.string ?? ""
        }
    
    var isEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,20}"
        let emailTest  = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    var trimmedWhiteSpaces: String {
        return self.trimmingCharacters(in: .whitespaces)
    }
    
    var length: Int {
        return self.count
    }
    
    var isMobileNumber: Bool {
        if length == 10 {
            return true
        } else {
            return false
        }
    }
    
    func onTrimIsEmpty() -> Bool {
        
        return self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    func isValidPhoneNumber() -> Bool {
        let phoneRegex = "^[1-9][0-9]{9}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: self)
    }
    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
    
    /* Password must be a minimum of 8 characters with at least one special character or numeric, at least one uppercase letter & at least one lower case letter.
     
     var isValidPassword: Bool {
     let passwordRegEx = "^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[@_#$%^&+=!])(?=\\S+$).{6,16}$"
     let passwordTest  = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
     return passwordTest.evaluate(with: self)
     }
     */
    
    //Password must be a minimum of 6 alphanumeric characters.
    // fixed https://github.com/ramankapur/NODAT/issues/424
    
    var isValidPassword: Bool {
        let passwordRegEx = "^(?=.*\\d)(?=.*([a-z]|[A-Z]))(?!.*\\s).{6,}$" // alphanumeric with special character > 6
        let passwordTest  = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return passwordTest.evaluate(with: self)
    }
    
    // here, `try!` will always succeed because the pattern is valid
    /*var isValidEmail: Bool {
     let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
     return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
     }*/
    
    var isValidEmail: Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: self)
    }
    
    func condenseWhitespace() -> String {
        let components = self.components(separatedBy: NSCharacterSet.whitespacesAndNewlines)
        if components.count > 0 {
            return components.filter { !$0.isEmpty }.joined(separator: " ")
        } else {
            return self
        }
    }
    func withBoldText(text: String, font: UIFont? = nil) -> NSAttributedString {
        let _font = font ?? UIFont.systemFont(ofSize: 16, weight: .regular)
        let fullString = NSMutableAttributedString(string: self, attributes: [NSAttributedString.Key.font: _font])
        let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: _font.pointSize)]
        let range = (self as NSString).range(of: text)
        fullString.addAttributes(boldFontAttribute, range: range)
        return fullString
    }
    
    var isValidFirstname:Bool{
        let nameFormat = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_"
        let validName = NSPredicate(format:"SELF MATCHES %@", nameFormat)
        return validName.evaluate(with: self)
    }
    
    //: ### Base64 encoding a string
    func base64Encoded() -> String? {
        if let data = self.data(using: .utf8) {
            return data.base64EncodedString()
        }
        return nil
    }
    
    //: ### Base64 decoding a string
    func base64Decoded() -> String {
        
        if let data = Data(base64Encoded: self) {
            return String(data: data, encoding: .utf8) ?? self
        }
        return self
    }
    func removeFromSubstring(_ str:String) -> String {
        if let index = self.range(of: str)?.lowerBound {
            let substring = self[..<index]                 // "ora"
            // or  let substring = word.prefix(upTo: index) // "ora"
            // (see picture below) Using the prefix(upTo:) method is equivalent to using a partial half-open range as the collection’s subscript.
            // The subscript notation is preferred over prefix(upTo:).
            
            return String(substring)
        }
        return ""
    }
    
    
    func toDouble() -> Double {
        if let unwrappedNum = Double(self) {
            return unwrappedNum
        } else {
            // Handle a bad number
            print("Error converting \"" + self + "\" to Double")
            return 0.0
        }
    }
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    
    var firstUppercased: String { return prefix(1).uppercased() + dropFirst() }
    var firstCapitalized: String { return prefix(1).capitalized + dropFirst() }
    
    
    func applyPatternOnNumbers(pattern: String, replacmentCharacter: Character) -> String {
        var pureNumber = self.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
        for index in 0 ..< pattern.count {
            guard index < pureNumber.count else { return pureNumber }
            let stringIndex = String.Index(utf16Offset: index, in: self)
            let patternCharacter = pattern[stringIndex]
            guard patternCharacter != replacmentCharacter else { continue }
            pureNumber.insert(patternCharacter, at: stringIndex)
        }
        return pureNumber
    }
    
    
    func currencyInputFormatting() -> String {
        
        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = ""
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        var amountWithPrefix = self
        
        // remove from String: "$", ".", ","
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "")
        
        let double = (amountWithPrefix as NSString).doubleValue
        number = NSNumber(value: (double / 100))
        
        // if first number is 0 or all numbers were deleted
        guard number != 0 as NSNumber else {
            return ""
        }
        
        return formatter.string(from: number)!
    }
    func convertToDictionary() -> [String: Any]? {
        if let data = data(using: .utf8) {
            return try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        }
        return nil
    }
    var youtubeID: String? {
        let pattern = "((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)"
        
        let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        let range = NSRange(location: 0, length: count)
        
        guard let result = regex?.firstMatch(in: self, range: range) else {
            return nil
        }
        
        return (self as NSString).substring(with: result.range)
    }
    
    
}
extension CGFloat{
    var cleanValue: String{
        //return String(format: 1 == floor(self) ? "%.0f" : "%.2f", self)
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(format: "%.0f", self)//
    }
    
    var dp: CGFloat {
        
        return (self / 375) * UIScreen.main.bounds.width
        
        //        (self * UIScreen.main.bounds.width) / 375
    }
   
}
