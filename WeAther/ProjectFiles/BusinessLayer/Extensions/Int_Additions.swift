//
//  Int+Additions.swift
//  KidsPlatform
//
//  Created by PC-009 on 24/02/21.
//

import Foundation

extension Int {
    var boolValue: Bool { return self != 0 }
    var abbreviated: String {
        let abbrev = "KMBTPE"
        return Array(abbrev).enumerated().reversed().reduce(nil as String?) { accum, tuple in
            let factor = Double(self) / pow(10, Double(tuple.0 + 1) * 3)
            let format = (factor.truncatingRemainder(dividingBy: 1)  == 0 ? "%.0f%@" : "%.1f%@")
            return accum ?? (factor > 1 ? String(format: format, factor, String(tuple.1)) : nil)
            } ?? String(self)
    }
    
    var toString: String {
        return "\(self)"
    }
}
