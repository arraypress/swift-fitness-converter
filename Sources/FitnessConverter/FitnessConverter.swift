//
//  FitnessConverter.swift
//  FitnessConverter
//
//  A comprehensive fitness measurement converter for health and exercise calculations
//  Created on 02/08/2025.
//

import Foundation

// MARK: - Main Public API

/// A comprehensive fitness measurement converter for health and exercise calculations.
///
/// FitnessConverter handles common fitness-related conversions and calculations including
/// running pace conversions, BMI calculations, distance conversions, and body measurement
/// transformations. Perfect for fitness apps, health platforms, and international workout tracking.
///
/// ## Key Features
///
/// - **Pace Conversions**: Convert running/walking pace between miles and kilometers
/// - **BMI Calculations**: Calculate Body Mass Index with different unit systems
/// - **Distance Conversions**: Miles ↔ Kilometers, Meters, etc.
/// - **Weight Conversions**: Pounds ↔ Kilograms with precision
/// - **Height Conversions**: Feet/inches ↔ Centimeters ↔ Meters
/// - **Calorie Estimations**: Basic calorie burn calculations
/// - **Confidence Scoring**: Indicates reliability of estimations
/// - **International Support**: US Imperial and Metric systems
///
/// ## Example Usage
///
/// ```swift
/// // Convert running pace from miles to kilometers
/// let kmPace = FitnessConverter.convertPace(
///     "7:30",
///     from: .minutesPerMile,
///     to: .minutesPerKilometer
/// )
/// // Result: "4:39" (per kilometer)
///
/// // Calculate BMI with mixed units
/// let bmi = FitnessConverter.calculateBMI(
///     weight: 150,
///     height: 68,
///     weightUnit: .pounds,
///     heightUnit: .inches
/// )
/// // Result: 22.8
///
/// // Convert workout distance
/// let kilometers = FitnessConverter.convertDistance(
///     5.0,
///     from: .miles,
///     to: .kilometers
/// )
/// // Result: 8.05 km
/// ```
///
/// ## Supported Conversions
///
/// - **Distance Units**: miles, kilometers, meters, yards, feet
/// - **Weight Units**: pounds, kilograms, stones
/// - **Height Units**: feet/inches, centimeters, meters
/// - **Pace Units**: minutes per mile, minutes per kilometer
/// - **Speed Units**: mph, km/h, m/s
/// - **Health Calculations**: BMI, target heart rate zones
///
/// ## Accuracy Notes
///
/// Calculations use internationally recognized formulas and conversion factors.
/// Health-related calculations (BMI, calorie estimates) are for informational purposes
/// and should not replace professional medical advice.
public struct FitnessConverter {
    
    /// Convert running or walking pace between different units.
    ///
    /// Pace represents the time required to cover a specific distance (e.g., minutes per mile).
    /// This method converts between mile-based and kilometer-based pace measurements while
    /// maintaining the same actual speed.
    ///
    /// ## Supported Pace Formats
    ///
    /// - **String format**: "7:30", "5:45", "10:15" (minutes:seconds)
    /// - **Decimal minutes**: 7.5, 5.75, 10.25
    /// - **Total seconds**: 450, 345, 615
    ///
    /// ## Example
    /// ```swift
    /// // Convert 7:30 mile pace to kilometer pace
    /// let kmPace = FitnessConverter.convertPace(
    ///     "7:30",
    ///     from: .minutesPerMile,
    ///     to: .minutesPerKilometer
    /// )
    /// // Result: "4:39" (faster per km because km is shorter)
    ///
    /// // Convert using decimal minutes
    /// let milePace = FitnessConverter.convertPace(
    ///     4.65,
    ///     from: .minutesPerKilometer,
    ///     to: .minutesPerMile
    /// )
    /// // Result: "7:30"
    /// ```
    ///
    /// - Parameters:
    ///   - pace: Pace value as string ("7:30") or numeric (7.5)
    ///   - fromUnit: Source pace unit
    ///   - toUnit: Target pace unit
    /// - Returns: Converted pace in the same format as input, or nil if conversion fails
    public static func convertPace<T: PaceConvertible & Sendable>(
        _ pace: T,
        from fromUnit: PaceUnit,
        to toUnit: PaceUnit
    ) -> T? {
        return convertPaceWithDetails(pace, from: fromUnit, to: toUnit).convertedPace
    }
    
    /// Convert pace with detailed conversion information.
    ///
    /// Provides comprehensive pace conversion results including confidence scores
    /// and helpful notes about the conversion accuracy and context.
    ///
    /// ## Example
    /// ```swift
    /// let result = FitnessConverter.convertPaceWithDetails(
    ///     "7:30",
    ///     from: .minutesPerMile,
    ///     to: .minutesPerKilometer
    /// )
    ///
    /// print("Converted pace: \(result.convertedPace ?? "N/A")")
    /// print("Confidence: \(result.confidence)")
    /// print("Equivalent speed: \(result.notes ?? "")")
    /// ```
    ///
    /// - Parameters:
    ///   - pace: Pace value to convert
    ///   - fromUnit: Source pace unit
    ///   - toUnit: Target pace unit
    /// - Returns: Detailed conversion result with metadata
    public static func convertPaceWithDetails<T: PaceConvertible & Sendable>(
        _ pace: T,
        from fromUnit: PaceUnit,
        to toUnit: PaceUnit
    ) -> FitnessConversionResult<T> {
        
        guard let paceInSeconds = pace.toSeconds() else {
            return FitnessConversionResult(
                originalValue: pace,
                fromUnit: AnyFitnessUnit(fromUnit),
                toUnit: AnyFitnessUnit(toUnit),
                calculationType: .paceConversion,
                error: .invalidPaceFormat(String(describing: pace))
            )
        }
        
        guard fromUnit != toUnit else {
            return FitnessConversionResult(
                originalValue: pace,
                convertedPace: pace,
                fromUnit: AnyFitnessUnit(fromUnit),
                toUnit: AnyFitnessUnit(toUnit),
                calculationType: .paceConversion,
                confidence: 1.0,
                notes: "Same pace unit - no conversion needed"
            )
        }
        
        let convertedSeconds = convertPaceSeconds(paceInSeconds, from: fromUnit, to: toUnit)
        guard let convertedPace = T.fromSeconds(convertedSeconds) else {
            return FitnessConversionResult(
                originalValue: pace,
                fromUnit: AnyFitnessUnit(fromUnit),
                toUnit: AnyFitnessUnit(toUnit),
                calculationType: .paceConversion,
                error: .conversionFailed("Could not format converted pace")
            )
        }
        
        let speedMph = 60.0 / (Double(paceInSeconds) / 60.0) // Convert pace to mph
        let notes = "Equivalent to \(String(format: "%.1f", speedMph)) mph"
        
        return FitnessConversionResult(
            originalValue: pace,
            convertedPace: convertedPace,
            fromUnit: AnyFitnessUnit(fromUnit),
            toUnit: AnyFitnessUnit(toUnit),
            calculationType: .paceConversion,
            confidence: 1.0,
            notes: notes
        )
    }
    
    /// Calculate Body Mass Index (BMI) with flexible unit support.
    ///
    /// BMI is a measure of body fat based on height and weight. The calculation uses
    /// the standard formula: BMI = weight (kg) / height (m)². This method accepts
    /// weights in pounds or kilograms and heights in various formats.
    ///
    /// ## BMI Categories (WHO Standard)
    ///
    /// - **Underweight**: BMI < 18.5
    /// - **Normal weight**: BMI 18.5-24.9
    /// - **Overweight**: BMI 25.0-29.9
    /// - **Obesity**: BMI ≥ 30.0
    ///
    /// ## Example
    /// ```swift
    /// // Using US units (pounds, feet/inches)
    /// let bmi1 = FitnessConverter.calculateBMI(
    ///     weight: 150,
    ///     height: 68,
    ///     weightUnit: .pounds,
    ///     heightUnit: .inches
    /// )
    /// // Result: 22.8
    ///
    /// // Using metric units
    /// let bmi2 = FitnessConverter.calculateBMI(
    ///     weight: 70,
    ///     height: 175,
    ///     weightUnit: .kilograms,
    ///     heightUnit: .centimeters
    /// )
    /// // Result: 22.9
    /// ```
    ///
    /// - Parameters:
    ///   - weight: Body weight
    ///   - height: Height measurement
    ///   - weightUnit: Unit for weight (.pounds, .kilograms, .stones)
    ///   - heightUnit: Unit for height (.inches, .centimeters, .meters, .feet)
    /// - Returns: BMI value rounded to 1 decimal place, or nil if calculation fails
    /// - Note: For informational purposes only - consult healthcare providers for medical advice
    public static func calculateBMI(
        weight: Double,
        height: Double,
        weightUnit: WeightUnit,
        heightUnit: HeightUnit
    ) -> Double? {
        return calculateBMIWithDetails(
            weight: weight,
            height: height,
            weightUnit: weightUnit,
            heightUnit: heightUnit
        ).calculatedValue
    }
    
    /// Calculate BMI with detailed health information.
    ///
    /// Provides BMI calculation along with category classification and health context.
    ///
    /// ## Example
    /// ```swift
    /// let result = FitnessConverter.calculateBMIWithDetails(
    ///     weight: 150,
    ///     height: 68,
    ///     weightUnit: .pounds,
    ///     heightUnit: .inches
    /// )
    ///
    /// print("BMI: \(result.calculatedValue ?? 0)")
    /// print("Category: \(result.notes ?? "")")
    /// ```
    ///
    /// - Parameters:
    ///   - weight: Body weight
    ///   - height: Height measurement
    ///   - weightUnit: Unit for weight
    ///   - heightUnit: Unit for height
    /// - Returns: Detailed BMI calculation result with health category
    public static func calculateBMIWithDetails(
        weight: Double,
        height: Double,
        weightUnit: WeightUnit,
        heightUnit: HeightUnit
    ) -> FitnessConversionResult<Double> {
        
        guard weight > 0 && height > 0 else {
            return FitnessConversionResult(
                originalValue: weight,
                fromUnit: AnyFitnessUnit(weightUnit),
                toUnit: AnyFitnessUnit(heightUnit),
                calculationType: .bmi,
                error: .invalidMeasurement("Weight and height must be positive")
            )
        }
        
        // Convert to metric (kg, meters)
        let weightKg = convertWeight(weight, from: weightUnit, to: .kilograms)
        let heightM = convertHeight(height, from: heightUnit, to: .meters)
        
        // Calculate BMI: weight (kg) / height (m)²
        let bmi = weightKg / (heightM * heightM)
        let roundedBMI = (bmi * 10).rounded() / 10 // Round to 1 decimal place
        
        let category = getBMICategory(roundedBMI)
        let notes = "BMI Category: \(category)"
        
        return FitnessConversionResult(
            originalValue: weight,
            calculatedValue: roundedBMI,
            fromUnit: AnyFitnessUnit(weightUnit),
            toUnit: AnyFitnessUnit(heightUnit),
            calculationType: .bmi,
            confidence: 0.95,
            notes: notes
        )
    }
    
    /// Convert distance between different units.
    ///
    /// Handles conversion between various distance measurements commonly used in fitness
    /// and exercise tracking. Supports metric and imperial units with high precision.
    ///
    /// ## Example
    /// ```swift
    /// // Convert race distances
    /// let marathon = FitnessConverter.convertDistance(26.2, from: .miles, to: .kilometers)
    /// // Result: 42.16 km
    ///
    /// let track = FitnessConverter.convertDistance(400, from: .meters, to: .yards)
    /// // Result: 437.45 yards
    /// ```
    ///
    /// - Parameters:
    ///   - distance: Distance value to convert
    ///   - fromUnit: Source distance unit
    ///   - toUnit: Target distance unit
    /// - Returns: Converted distance value, or nil if conversion fails
    public static func convertDistance(
        _ distance: Double,
        from fromUnit: DistanceUnit,
        to toUnit: DistanceUnit
    ) -> Double? {
        guard distance >= 0 else { return nil }
        guard fromUnit != toUnit else { return distance }
        
        // Convert to meters as base unit, then to target
        let meters = distance * fromUnit.toMeters
        return meters / toUnit.toMeters
    }
    
    /// Convert weight between different units.
    ///
    /// Supports conversion between common weight units used in fitness tracking
    /// and health measurements.
    ///
    /// ## Example
    /// ```swift
    /// let kg = FitnessConverter.convertWeight(150, from: .pounds, to: .kilograms)
    /// // Result: 68.04 kg
    ///
    /// let stones = FitnessConverter.convertWeight(70, from: .kilograms, to: .stones)
    /// // Result: 11.02 stones
    /// ```
    ///
    /// - Parameters:
    ///   - weight: Weight value to convert
    ///   - fromUnit: Source weight unit
    ///   - toUnit: Target weight unit
    /// - Returns: Converted weight value
    public static func convertWeight(
        _ weight: Double,
        from fromUnit: WeightUnit,
        to toUnit: WeightUnit
    ) -> Double {
        guard fromUnit != toUnit else { return weight }
        
        // Convert to kilograms as base unit, then to target
        let kilograms = weight * fromUnit.toKilograms
        return kilograms / toUnit.toKilograms
    }
    
    /// Convert height between different units.
    ///
    /// Handles height conversions including feet/inches combinations and metric units.
    ///
    /// ## Example
    /// ```swift
    /// let cm = FitnessConverter.convertHeight(68, from: .inches, to: .centimeters)
    /// // Result: 172.72 cm
    ///
    /// let feet = FitnessConverter.convertHeight(175, from: .centimeters, to: .feet)
    /// // Result: 5.74 feet
    /// ```
    ///
    /// - Parameters:
    ///   - height: Height value to convert
    ///   - fromUnit: Source height unit
    ///   - toUnit: Target height unit
    /// - Returns: Converted height value
    public static func convertHeight(
        _ height: Double,
        from fromUnit: HeightUnit,
        to toUnit: HeightUnit
    ) -> Double {
        guard fromUnit != toUnit else { return height }
        
        // Convert to meters as base unit, then to target
        let meters = height * fromUnit.toMeters
        return meters / toUnit.toMeters
    }
    
    /// Get comprehensive information about converter capabilities.
    ///
    /// Returns metadata about supported units, calculations, and conversion types.
    /// Useful for building user interfaces or validating conversion requests.
    ///
    /// ## Example
    /// ```swift
    /// let info = FitnessConverter.conversionInfo()
    /// print("Supported calculations: \(info.supportedCalculations.count)")
    /// print("Distance units: \(info.distanceUnits.count)")
    /// ```
    ///
    /// - Returns: Comprehensive conversion capability information
    public static func conversionInfo() -> FitnessConversionInfo {
        return FitnessConversionInfo(
            supportedCalculations: CalculationType.allCases,
            distanceUnits: DistanceUnit.allCases,
            weightUnits: WeightUnit.allCases,
            heightUnits: HeightUnit.allCases,
            paceUnits: PaceUnit.allCases,
            description: "Professional fitness measurement converter with international unit support"
        )
    }
    
}
