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
}
