//
//  PaceUnit.swift
//  FitnessConverter
//
//  Created by David Sherlock on 02/08/2025.
//

import Foundation

/// Pace measurement units for running and walking.
///
/// Pace represents the time required to cover a specific distance.
/// Different from speed, which represents distance per time.
public enum PaceUnit: String, CaseIterable, Sendable {
    
    /// Minutes per mile (common in US)
    case minutesPerMile = "min/mile"
    
    /// Minutes per kilometer (common internationally)
    case minutesPerKilometer = "min/km"
    
    /// Human-readable full name
    public var fullName: String {
        switch self {
        case .minutesPerMile: return "Minutes per Mile"
        case .minutesPerKilometer: return "Minutes per Kilometer"
        }
    }
    
    /// Short abbreviation
    public var abbreviation: String {
        return rawValue
    }
    
    /// Distance covered in this pace unit (in meters)
    public var distanceInMeters: Double {
        switch self {
        case .minutesPerMile: return 1609.344
        case .minutesPerKilometer: return 1000.0
        }
    }
    
}
