//
//  FitnessConversionError.swift
//  FitnessConverter
//
//  Created by David Sherlock on 02/08/2025.
//

import Foundation

/// Errors that can occur during fitness conversions and calculations.
public enum FitnessConversionError: Error, LocalizedError, Equatable, Sendable {
    /// Invalid pace format (e.g., "7:75" or "abc")
    case invalidPaceFormat(String)
    
    /// Invalid measurement value (negative weight, zero height, etc.)
    case invalidMeasurement(String)
    
    /// Calculation failed due to mathematical constraints
    case calculationFailed(String)
    
    /// Conversion between these units is not supported
    case unsupportedConversion(from: String, to: String)
    
    /// Generic conversion failure
    case conversionFailed(String)
    
    /// Value out of reasonable range
    case valueOutOfRange(String, validRange: String)
    
    public var errorDescription: String? {
        switch self {
        case .invalidPaceFormat(let format):
            return "Invalid pace format: '\(format)'. Expected format like '7:30' or decimal minutes."
        case .invalidMeasurement(let message):
            return "Invalid measurement: \(message)"
        case .calculationFailed(let reason):
            return "Calculation failed: \(reason)"
        case .unsupportedConversion(let from, let to):
            return "Cannot convert from \(from) to \(to)"
        case .conversionFailed(let reason):
            return "Conversion failed: \(reason)"
        case .valueOutOfRange(let value, let range):
            return "Value '\(value)' out of valid range: \(range)"
        }
    }
    
    /// User-friendly error message
    public var userFriendlyDescription: String {
        switch self {
        case .invalidPaceFormat:
            return "Please enter pace as '7:30' or decimal minutes like '7.5'"
        case .invalidMeasurement(let message):
            return message
        case .calculationFailed:
            return "Could not complete the calculation with provided values"
        case .unsupportedConversion:
            return "This conversion is not supported"
        case .conversionFailed:
            return "Conversion could not be completed"
        case .valueOutOfRange(_, let range):
            return "Please enter a value in the range: \(range)"
        }
    }
}
