//
//  StringExtensions.swift
//  Digipro
//
//  Created by Jonathan Viloria M on 01/08/18.
//  Copyright © 2018 Digipro Movil. All rights reserved.
//

import Foundation

public extension String {
    
    /* Truncate Long String */
    func trunc(length: Int, trailing: String = "…") -> String {
        return (self.count > length) ? self.prefix(length) + trailing : self
    }
    
    //: ### Base64 encoding a string
    func base64Encoded() -> String? {
        if let data = self.data(using: .utf8) {
            return data.base64EncodedString()
        }
        return nil
    }
    //: ### Base64 decoding a string
    func base64Decoded() -> String? {
        if let data = Data(base64Encoded: self) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
    
    // REGEX
    func regexReplace(regEx : String) -> String {
        let regex = try! NSRegularExpression(pattern: regEx, options: NSRegularExpression.Options.caseInsensitive)
        let range = NSMakeRange(0, self.count)
        let modString = regex.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "")
        return modString
    }
    
    func regexMatches(regex: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: self,
                                        range: NSRange(self.startIndex..., in: self))
            return results.map {
                String(self[Range($0.range, in: self)!])
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
    // String Base64 to NSData
    func stringBase64EncodeToData() -> NSData{
        let base64String = self
        let dataDecoded:NSData = NSData(base64Encoded: base64String, options: NSData.Base64DecodingOptions(rawValue: 0))!
        return dataDecoded
    }
    
    // String Base64 To Image
    func stringBase64EncodeToImage() -> UIImage{
        let base64String = self
        let dataDecoded:NSData = NSData(base64Encoded: base64String, options: NSData.Base64DecodingOptions(rawValue: 0))!
        let decodedimage:UIImage = UIImage(data: dataDecoded as Data)!
        return decodedimage
    }
    
    func stringbase64ToImage() -> UIImage?{
        /* Getting Logo Image to Splash Screen */
        var base64String = self
        
        if base64String.contains("data:image/png;base64,"){
            base64String = base64String.replacingOccurrences(of: "data:image/png;base64,", with: "")
        }else if base64String.contains("data:image/jpg;base64,"){
            base64String = base64String.replacingOccurrences(of: "data:image/jpg;base64,", with: "")
        }else if base64String.contains("data:image/jpeg;base64,"){
            base64String = base64String.replacingOccurrences(of: "data:image/jpeg;base64,", with: "")
        }else {
            base64String = ""
        }
        
        if base64String != ""{
            let dataDecoded:NSData = NSData(base64Encoded: base64String, options: NSData.Base64DecodingOptions(rawValue: 0))!
            let decodedimage:UIImage = UIImage(data: dataDecoded as Data)!
            return decodedimage
        }
        let decodedimage:UIImage? = nil
        return decodedimage
    }
    
    // Ranges
    subscript (bounds: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start...end])
    }
    
    subscript (bounds: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
    }
   
    func image(withAttributes attributes: [NSAttributedString.Key: Any]? = nil, size: CGSize? = nil) -> UIImage? {
        let size = size ?? (self as NSString).size(withAttributes: attributes)
        return UIGraphicsImageRenderer(size: size).image { _ in
            (self as NSString).draw(in: CGRect(origin: .zero, size: size),
                                    withAttributes: attributes)
        }
    }
    
}
