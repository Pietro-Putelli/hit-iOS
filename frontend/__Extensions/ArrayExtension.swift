//
//  ArrayExtension.swift
//  Hit
//
//  Created by Pietro Putelli on 22/04/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit

extension Array {
    @inlinable public var second: Element? {
        get {
            self[1]
        }
    }
    
    func toJson(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
}

extension Dictionary where Key == String, Value == AnyObject {
    func toString() -> String? {
        do {
            let data = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            let convertedString = String(data: data, encoding: .utf8)
            return convertedString
        } catch {
            return nil
        }
    }
}

extension Array where Element == Int {
    mutating func containsAppend(element: Int) {
        guard !contains(element) else {
            return
        }
        append(element)
    }
}

extension Array where Element == String {
    mutating func containsAppend(element: String) {
        guard !contains(element) else {
            return
        }
        append(element)
    }
}

extension Array {
    mutating func empties() {
        self = []
    }
}

extension Array where Element == IndexPath {

    func isElementAlreadyContained(for indexPath: IndexPath) -> Bool {
        for element in self {
            if element == indexPath {
                return true
            }
        }
        return false
    }
}

extension Array where Element == Int {
    var commaSeparated: String {
        return map{String($0)}.joined(separator: ",")
    }
}

extension Array where Element == Int {
    mutating func appendIfNotExists(_ element: Int) {
        if !contains(element) {
            append(element)
        }
    }
}

extension Array where Element == Comment {
    mutating func appendIfNoContains(_ contentsOf: [Comment]) {
        contentsOf.forEach { (element) in
            if !contains(element) {
                append(element)
            } else if let index = lastIndex(where: { $0 == element }) {
                remove(at: index)
            }
        }
    }
}
