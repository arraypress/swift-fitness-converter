//
//  ActivityLevel.swift
//  FitnessConverter
//
//  Support structures for fitness conversions and calculations
//  Created on 02/08/2025.
//

import Foundation

/// Activity level for calorie and fitness calculations
public enum ActivityLevel: String, CaseIterable, Sendable {
    
    case sedentary = "sedentary"
    case lightlyActive = "lightly_active"
    case moderatelyActive = "moderately_active"
    case veryActive = "very_active"
    case extraActive = "extra_active"
    
    public var description: String {
        switch self {
        case .sedentary: return "Sedentary"
        case .lightlyActive: return "Lightly Active"
        case .moderatelyActive: return "Moderately Active"
        case .veryActive: return "Very Active"
        case .extraActive: return "Extra Active"
        }
    }
    
    /// Activity multiplier for calorie calculations
    public var multiplier: Double {
        switch self {
        case .sedentary: return 1.2
        case .lightlyActive: return 1.375
        case .moderatelyActive: return 1.55
        case .veryActive: return 1.725
        case .extraActive: return 1.9
        }
    }
    
}
