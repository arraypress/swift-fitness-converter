//
//  CalculationType.swift
//  FitnessConverter
//
//  Created by David Sherlock on 02/08/2025.
//

import Foundation

/// Types of fitness calculations and conversions supported.
public enum CalculationType: String, CaseIterable, Sendable {
    
    /// Running/walking pace conversion
    case paceConversion = "pace"
    
    /// Body Mass Index calculation
    case bmi = "bmi"
    
    /// Distance unit conversion
    case distance = "distance"
    
    /// Weight unit conversion
    case weight = "weight"
    
    /// Height unit conversion
    case height = "height"
    
    /// Calorie estimation (future feature)
    case calories = "calories"
    
    /// Heart rate zone calculation (future feature)
    case heartRate = "heartRate"
    
    /// Human-readable description
    public var description: String {
        switch self {
        case .paceConversion:
            return "Pace Conversion (minutes per mile ↔ km)"
        case .bmi:
            return "Body Mass Index Calculation"
        case .distance:
            return "Distance Conversion (miles, km, meters)"
        case .weight:
            return "Weight Conversion (lbs, kg, stones)"
        case .height:
            return "Height Conversion (ft/in, cm, m)"
        case .calories:
            return "Calorie Burn Estimation"
        case .heartRate:
            return "Target Heart Rate Zones"
        }
    }
    
}
