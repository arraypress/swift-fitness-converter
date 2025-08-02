//
//  HeightUnit.swift
//  FitnessConverter
//
//  Created by David Sherlock on 02/08/2025.
//

import Foundation

/// Height measurement units for fitness and health calculations.
public enum HeightUnit: String, CaseIterable, Sendable {
    
    /// Inches (US/Imperial)
    case inches = "inches"
    
    /// Feet (US/Imperial) - for decimal feet like 5.75 feet
    case feet = "feet"
    
    /// Centimeters (Metric)
    case centimeters = "cm"
    
    /// Meters (Metric)
    case meters = "m"
    
    /// Conversion factor to meters (base unit)
    public var toMeters: Double {
        switch self {
        case .inches: return 0.0254
        case .feet: return 0.3048
        case .centimeters: return 0.01
        case .meters: return 1.0
        }
    }
    
    /// Human-readable full name
    public var fullName: String {
        switch self {
        case .inches: return "Inches"
        case .feet: return "Feet"
        case .centimeters: return "Centimeters"
        case .meters: return "Meters"
        }
    }
    
    /// Short abbreviation
    public var abbreviation: String {
        return rawValue
    }
    
}
