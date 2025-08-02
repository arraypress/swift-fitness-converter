//
//  FitnessConversionInfo.swift
//  FitnessConverter
//
//  Created by David Sherlock on 02/08/2025.
//

import Foundation

/// Comprehensive information about fitness converter capabilities.
public struct FitnessConversionInfo: Sendable {
    /// All supported calculation types
    public let supportedCalculations: [CalculationType]
    
    /// All supported distance units
    public let distanceUnits: [DistanceUnit]
    
    /// All supported weight units
    public let weightUnits: [WeightUnit]
    
    /// All supported height units
    public let heightUnits: [HeightUnit]
    
    /// All supported pace units
    public let paceUnits: [PaceUnit]
    
    /// Description of the converter
    public let description: String
    
    /// Total number of possible unit conversions
    public var totalUnitConversions: Int {
        let distance = distanceUnits.count * (distanceUnits.count - 1)
        let weight = weightUnits.count * (weightUnits.count - 1)
        let height = heightUnits.count * (heightUnits.count - 1)
        let pace = paceUnits.count * (paceUnits.count - 1)
        return distance + weight + height + pace
    }
    
    /// Units grouped by their usage context
    public var unitsByContext: [String: [String]] {
        return [
            "Distance": distanceUnits.map { $0.fullName },
            "Weight": weightUnits.map { $0.fullName },
            "Height": heightUnits.map { $0.fullName },
            "Pace": paceUnits.map { $0.fullName }
        ]
    }
    
    /// Common fitness calculations available
    public var availableCalculations: [String] {
        return supportedCalculations.map { $0.description }
    }
}
