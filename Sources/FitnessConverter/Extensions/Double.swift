//
//  Double.swift
//  FitnessConverter
//
//  Created by David Sherlock on 02/08/2025.
//

import Foundation

extension Double: PaceConvertible {
    /// Convert decimal minutes to total seconds
    public func toSeconds() -> Int? {
        guard self > 0 else { return nil }
        return Int(self * 60)
    }
    
    /// Create decimal minutes from total seconds
    public static func fromSeconds(_ seconds: Int) -> Double? {
        guard seconds > 0 else { return nil }
        return Double(seconds) / 60.0
    }

    // Decimal minutes can hold a fraction of a second, so nothing here needs
    // rounding — and rounding anyway is what made 4.6603 come back as 4.6667.

    public func toPreciseSeconds() -> Double? {
        guard self > 0 else { return nil }
        return self * 60
    }

    public static func fromPreciseSeconds(_ seconds: Double) -> Double? {
        guard seconds > 0 else { return nil }
        return seconds / 60.0
    }
}
