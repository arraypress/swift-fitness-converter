//
//  PaceConvertible.swift
//  FitnessConverter
//
//  Created by David Sherlock on 02/08/2025.
//

import Foundation

/// Protocol for types that can be converted to/from pace measurements.
///
/// Allows flexible pace input formats including strings ("7:30"),
/// decimal minutes (7.5), and total seconds (450).
public protocol PaceConvertible: Sendable {
    /// Convert this value to total seconds
    func toSeconds() -> Int?
    
    /// Create a value from total seconds
    static func fromSeconds(_ seconds: Int) -> Self?

    /// Convert this value to seconds without rounding to a whole one.
    ///
    /// A pace written as "7:30" is whole seconds by construction, but a pace
    /// held as decimal minutes is not, and neither is the result of converting
    /// one. Rounding at every step compounds: 7.5 min/mile is 4.6603 min/km,
    /// and a whole-second round trip reports 4.6667.
    ///
    /// Defaulted, so existing conformers need not implement it.
    func toPreciseSeconds() -> Double?

    /// Create a value from seconds that may carry a fraction.
    static func fromPreciseSeconds(_ seconds: Double) -> Self?
}

public extension PaceConvertible {

    func toPreciseSeconds() -> Double? {
        toSeconds().map(Double.init)
    }

    /// Rounds to the nearest whole second, which is right for any
    /// representation that cannot hold a fraction — a clock face above all.
    static func fromPreciseSeconds(_ seconds: Double) -> Self? {
        fromSeconds(Int(seconds.rounded()))
    }
}
