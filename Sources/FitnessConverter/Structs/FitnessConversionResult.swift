//
//  FitnessConversionResult.swift
//  FitnessConverter
//
//  Created by David Sherlock on 02/08/2025.
//

import Foundation

/// Detailed result of a fitness conversion or calculation.
///
/// Contains the conversion result along with metadata about confidence,
/// notes, and potential errors. This provides transparency about the
/// reliability and context of fitness calculations.
///
/// ## Generic Type Support
///
/// The result type is generic to support different value types:
/// - `FitnessConversionResult<String>` for pace conversions ("7:30")
/// - `FitnessConversionResult<Double>` for BMI calculations (22.8)
/// - `FitnessConversionResult<Int>` for pace in seconds (450)
public struct FitnessConversionResult<T>: Sendable where T: Sendable {
    /// Original value that was converted/calculated
    public let originalValue: T
    
    /// Converted value (for pace conversions)
    public let convertedPace: T?
    
    /// Calculated value (for BMI, calorie estimates, etc.)
    public let calculatedValue: T?
    
    /// Source unit or input type
    public let fromUnit: AnyFitnessUnit
    
    /// Target unit or result type
    public let toUnit: AnyFitnessUnit
    
    /// Type of calculation performed
    public let calculationType: CalculationType
    
    /// Confidence level of result (0.0 - 1.0)
    public let confidence: Double
    
    /// Error if calculation failed
    public let error: FitnessConversionError?
    
    /// Additional notes about the calculation
    public let notes: String?
    
    /// Whether the calculation was successful
    public var isSuccess: Bool {
        return (convertedPace != nil || calculatedValue != nil) && error == nil
    }
    
    /// The result value (converted pace or calculated value)
    public var resultValue: T? {
        return convertedPace ?? calculatedValue
    }
    
    /// Initialize a successful pace conversion result
    public init(
        originalValue: T,
        convertedPace: T,
        fromUnit: AnyFitnessUnit,
        toUnit: AnyFitnessUnit,
        calculationType: CalculationType,
        confidence: Double = 1.0,
        notes: String? = nil
    ) {
        self.originalValue = originalValue
        self.convertedPace = convertedPace
        self.calculatedValue = nil
        self.fromUnit = fromUnit
        self.toUnit = toUnit
        self.calculationType = calculationType
        self.confidence = confidence
        self.error = nil
        self.notes = notes
    }
    
    /// Initialize a successful calculation result (BMI, calories, etc.)
    public init(
        originalValue: T,
        calculatedValue: T,
        fromUnit: AnyFitnessUnit,
        toUnit: AnyFitnessUnit,
        calculationType: CalculationType,
        confidence: Double = 1.0,
        notes: String? = nil
    ) {
        self.originalValue = originalValue
        self.convertedPace = nil
        self.calculatedValue = calculatedValue
        self.fromUnit = fromUnit
        self.toUnit = toUnit
        self.calculationType = calculationType
        self.confidence = confidence
        self.error = nil
        self.notes = notes
    }
    
    /// Initialize a failed conversion/calculation result
    public init(
        originalValue: T,
        fromUnit: AnyFitnessUnit,
        toUnit: AnyFitnessUnit,
        calculationType: CalculationType,
        confidence: Double = 0.0,
        error: FitnessConversionError,
        notes: String? = nil
    ) {
        self.originalValue = originalValue
        self.convertedPace = nil
        self.calculatedValue = nil
        self.fromUnit = fromUnit
        self.toUnit = toUnit
        self.calculationType = calculationType
        self.confidence = confidence
        self.error = error
        self.notes = notes
    }
}
