//
//  DistanceUnit.swift
//  FitnessConverter
//
//  Created by David Sherlock on 02/08/2025.
//

import Foundation

/// Distance measurement units for fitness tracking.
///
/// Supports common distance units used in running, walking, cycling,
/// and other fitness activities across different measurement systems.
public enum DistanceUnit: String, CaseIterable, Sendable {
    /// Miles (US/Imperial)
    case miles = "miles"
    
    /// Kilometers (Metric)
    case kilometers = "km"
    
    /// Meters (Metric)
    case meters = "m"
    
    /// Yards (US/Imperial)
    case yards = "yards"
    
    /// Feet (US/Imperial)
    case feet = "feet"
    
    /// Conversion factor to meters (base unit)
    public var toMeters: Double {
        switch self {
        case .miles: return 1609.344
        case .kilometers: return 1000.0
        case .meters: return 1.0
        case .yards: return 0.9144
        case .feet: return 0.3048
        }
    }
    
    /// Human-readable full name
    public var fullName: String {
        switch self {
        case .miles: return "Miles"
        case .kilometers: return "Kilometers"
        case .meters: return "Meters"
        case .yards: return "Yards"
        case .feet: return "Feet"
        }
    }
    
    /// Short abbreviation
    public var abbreviation: String {
        return rawValue
    }
}
