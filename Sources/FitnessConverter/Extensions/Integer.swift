//
//  Integer.swift
//  FitnessConverter
//
//  Created by David Sherlock on 02/08/2025.
//

import Foundation

extension Int: PaceConvertible {
    /// Convert total seconds to total seconds (passthrough)
    public func toSeconds() -> Int? {
        guard self > 0 else { return nil }
        return self
    }
    
    /// Create total seconds from total seconds (passthrough)
    public static func fromSeconds(_ seconds: Int) -> Int? {
        guard seconds > 0 else { return nil }
        return seconds
    }
}
