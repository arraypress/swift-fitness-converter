//
//  FitnessStructs.swift
//  FitnessConverter
//
//  Support structures for fitness conversions and calculations
//  Created on 02/08/2025.
//

import Foundation

/// Represents a user's fitness profile for calculations.
///
/// Used for more advanced calculations that require multiple measurements
/// or personal information (future enhancement).
public struct FitnessProfile: Sendable {
    /// Age in years
    public let age: Int?
    
    /// Gender (affects some calculations like target heart rate)
    public let gender: Gender?
    
    /// Activity level (affects calorie calculations)
    public let activityLevel: ActivityLevel?
    
    /// Resting heart rate (for heart rate zone calculations)
    public let restingHeartRate: Int?
    
    public init(
        age: Int? = nil,
        gender: Gender? = nil,
        activityLevel: ActivityLevel? = nil,
        restingHeartRate: Int? = nil
    ) {
        self.age = age
        self.gender = gender
        self.activityLevel = activityLevel
        self.restingHeartRate = restingHeartRate
    }
}
