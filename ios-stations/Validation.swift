//
//  Validation.swift
//  ios-stations
//
//  Created by 内藤広貴 on 2024/01/23.
//

import Foundation

extension String {
    func isEmail() -> Bool {
        let pattern = "^[\\w\\.\\-_]+@[\\w\\.\\-_]+\\.[a-zA-Z]+$"
        let matches = validate(str: self, pattern: pattern)
        return matches.count > 0
    }
    
    func isPassword() -> Bool {
        let pattern = "^.{8,}$"
        let matches = validate(str: self, pattern: pattern)
        return matches.count > 0
    }
    
    private func validate(str: String, pattern: String) -> [NSTextCheckingResult] {
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return [] }
        return regex.matches(in: str, range: NSRange(location: 0, length: str.count))
    }
}
