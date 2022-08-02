//
//  StringExtension.swift
//  Todo
//
//  Created by developer on 7/31/22.
//

import Foundation

extension String {
    
    static func split(_ string: String, by splitChar: String = ", ") -> [String] {
        let result = string.components(separatedBy: splitChar)
        return result
    }
    
    static func combine(_ array: [String], using combineChar: String = ", ") -> String {
        var result = ""
        for arr in array {
            if arr != array.last {
                result += "\(arr)\(combineChar)"
            } else {
                result += arr
            }
        }
        return result
    }
}
