//
//  String.swift
//  FitnessConverter
//
//  Created by David Sherlock on 02/08/2025.
//

import Foundation

extension String: PaceConvertible {
    /// Convert pace string like "7:30" to total seconds
    public func toSeconds() -> Int? {
        let components = self.split(separator: ":").compactMap { Int($0) }
        guard components.count == 2 else { return nil }
        let minutes = components[0]
        let seconds = components[1]
        guard minutes >= 0, seconds >= 0, seconds < 60 else { return nil }
        return minutes * 60 + seconds
    }
    
    /// Create pace string from total seconds
    public static func fromSeconds(_ seconds: Int) -> String? {
        guard seconds > 0 else { return nil }
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%d:%02d", minutes, remainingSeconds)
    }
}
