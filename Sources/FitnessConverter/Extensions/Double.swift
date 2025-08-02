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
}
