//
// Created by Glenn Martin on 6/9/17.
// Copyright (c) 2017 Glenn R. Martin. All rights reserved.
//

import Foundation

protocol OptionalString {}
extension String: OptionalString {}

extension String {
    subscript(i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }

    subscript(i: Int) -> String {
        return String(self[i] as Character)
    }

    func isNullOrEmpty() -> Bool {
        return (self as String?).isNullOrEmpty()
    }

    func toConstantComparison() -> String! {
        return (self as String?).toConstantComparison()
    }
}

extension Optional where Wrapped: OptionalString {
    func isNullOrEmpty() -> Bool {
        if (self == nil) { return true; }

        let val = (self as! String).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

        return val.isEmpty
    }

    func toConstantComparison() -> String! {
        return (self == nil ?  "" : self as! String).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).localizedLowercase
    }
}
