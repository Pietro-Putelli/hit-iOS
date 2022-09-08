//
//  StringExtension.swift
//  Hit
//
//  Created by Pietro Putelli on 03/02/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit

extension String {
    
    var isUsernameEmpty: Bool {
        return !(trimmingCharacters(in: .whitespaces).count < 1)
    }
    
    var isEmptyTrimmingSpaces: Bool {
        return trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    var isEmailAddress: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    var isValidUsername : Bool {
        let userNameRegEx = "^[a-z0-9_.]{1,13}$"

        let userNameChecker = NSPredicate(format:"SELF MATCHES[c] %@", userNameRegEx)
        return userNameChecker.evaluate(with: self)
    }
    
    var containsSpaces: Bool {
        return rangeOfCharacter(from: NSCharacterSet.whitespaces) != nil
    }
    
    var containsOnlyWhiteSpacesOrNewLines: Bool {
        let trimmedText = filter {
            !$0.isNewline && !$0.isWhitespace
        }
        return trimmedText.isEmpty
    }
    
    var numberOfSnails: Int {
        return filter { $0 == "@" }.count
    }
    
    var emptyString: String {
        return ""
    }
    
    var whiteSpace: String {
        return " "
    }
}

extension String {
    
    func stringFrom(wordRange: NSRange) -> String {
        let stringCharacters = Array(self)
        var characters = [Character]()
        
        for i in wordRange.lowerBound...(wordRange.upperBound - 1) where i < stringCharacters.count {
            characters.append(stringCharacters[i])
        }
        return String(characters)
    }
}

extension String {
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
}

public extension NSRange {
    
    init(string: String, lowerBound: String.Index, upperBound: String.Index) {
        let utf16 = string.utf16

        let lowerBound = lowerBound.samePosition(in: utf16)
        let location = utf16.distance(from: utf16.startIndex, to: lowerBound!)
        let length = utf16.distance(from: lowerBound!, to: upperBound.samePosition(in: utf16)!)

        self.init(location: location, length: length)
    }

    init(range: Range<String.Index>, in string: String) {
        self.init(string: string, lowerBound: range.lowerBound, upperBound: range.upperBound)
    }

    init(range: ClosedRange<String.Index>, in string: String) {
        self.init(string: string, lowerBound: range.lowerBound, upperBound: range.upperBound)
    }
}
extension String {
    func toArray() -> [Int] {
        var string = String()
        var strings = [String]()
        
        for character in self {
            if character != .comma {
                string.append(character)
            } else {
                strings.append(string)
                string = ""
            }
        }
        if !strings.contains(string) {
            strings.append(string)
        }
        
        guard !string.isEmpty else {
            return []
        }
        return strings.map { Int($0)! }
    }
}

// === CUSTOM STRINGS / CHARACTERS

extension Character {
    static var whiteSpace: Character {
        return " "
    }
    
    static var snail: Character {
        return "@"
    }
    
    static var comma: Character {
        return ","
    }
}

extension String {
    static var post: String {
        return "POST"
    }
    
    static var snail: String {
        return "@"
    }
    
    static var whiteSpace: String {
        return " "
    }
    
    static var response: String {
        return "response"
    }
}

extension Optional where Wrapped == String {
    
    var emptyIfNil: String {
        return self == nil ? "" : self!
    }
}

extension String {
    var utf8: Data? {
        return data(using: .utf8)
    }
}

extension String {
    var commaSeparatedToIntArray: [Int] {
        return components(separatedBy: ",")
            .compactMap {
                Int($0.trimmingCharacters(in: .whitespaces))
            }
    }
}

extension String {
    var commaSeparatedToStringArray: [String] {
        return components(separatedBy: ",")
            .compactMap {
                $0.trimmingCharacters(in: .whitespaces)
            }
    }
}

extension StringProtocol {
    var lines: [SubSequence] { split(whereSeparator: \.isNewline) }
    var removeAllExtraNewLines: String { lines.joined(separator: "\n") }
}

extension String {
    var notEmpty: Bool {
        return self != ""
    }
}
