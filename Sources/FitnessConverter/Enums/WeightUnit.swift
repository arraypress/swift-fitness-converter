//
//  WeightUnit.swift
//  FitnessConverter
//
//  Created by David Sherlock on 02/08/2025.
//

import Foundation

/// Weight measurement units for fitness and health tracking.
public enum WeightUnit: String, CaseIterable, Sendable {
    
    /// Pounds (US/Imperial)
    case pounds = "lbs"
    
    /// Kilograms (Metric)
    case kilograms = "kg"
    
    /// Stones (UK Imperial)
    case stones = "stones"
    
    /// Conversion factor to kilograms (base unit)
    public var toKilograms: Double {
        switch self {
        case .pounds: return 0.453592
        case .kilograms: return 1.0
        case .stones: return 6.35029
        }
    }
    
    /// Human-readable full name
    public var fullName: String {
        switch self {
        case .pounds: return "Pounds"
        case .kilograms: return "Kilograms"
        case .stones: return "Stones"
        }
    }
    
    /// Short abbreviation
    public var abbreviation: String {
        return rawValue
    }
    
}
