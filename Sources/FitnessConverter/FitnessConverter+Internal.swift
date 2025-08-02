//
//  FitnessConverter+Internal.swift
//  FitnessConverter
//
//  Internal conversion logic and helper methods
//  Created on 02/08/2025.
//

import Foundation

// MARK: - Internal Conversion Logic

extension FitnessConverter {
    
    /// Convert pace between units (internal implementation)
    internal static func convertPaceSeconds(
        _ paceInSeconds: Int,
        from fromUnit: PaceUnit,
        to toUnit: PaceUnit
    ) -> Int {
        guard fromUnit != toUnit else { return paceInSeconds }
        
        // Convert pace using distance ratio
        // If it takes X seconds to run 1 mile, how long for 1 km?
        // Time per km = (Time per mile) * (km distance / mile distance)
        
        let fromDistance = fromUnit.distanceInMeters
        let toDistance = toUnit.distanceInMeters
        let ratio = toDistance / fromDistance
        
        return Int(Double(paceInSeconds) * ratio)
    }
    
    /// Get BMI category classification
    internal static func getBMICategory(_ bmi: Double) -> String {
        switch bmi {
        case ..<18.5:
            return "Underweight"
        case 18.5..<25.0:
            return "Normal weight"
        case 25.0..<30.0:
            return "Overweight"
        case 30.0...:
            return "Obesity"
        default:
            return "Unknown"
        }
    }
    
    /// Calculate target heart rate zones based on age and resting HR
    internal static func calculateHeartRateZones(
        age: Int,
        restingHeartRate: Int
    ) -> [String: ClosedRange<Int>] {
        let maxHeartRate = 220 - age
        let heartRateReserve = maxHeartRate - restingHeartRate
        
        return [
            "Recovery": (restingHeartRate + Int(0.2 * Double(heartRateReserve)))...(restingHeartRate + Int(0.3 * Double(heartRateReserve))),
            "Aerobic Base": (restingHeartRate + Int(0.3 * Double(heartRateReserve)))...(restingHeartRate + Int(0.4 * Double(heartRateReserve))),
            "Aerobic": (restingHeartRate + Int(0.4 * Double(heartRateReserve)))...(restingHeartRate + Int(0.5 * Double(heartRateReserve))),
            "Lactate Threshold": (restingHeartRate + Int(0.5 * Double(heartRateReserve)))...(restingHeartRate + Int(0.6 * Double(heartRateReserve))),
            "VO2 Max": (restingHeartRate + Int(0.6 * Double(heartRateReserve)))...(restingHeartRate + Int(0.7 * Double(heartRateReserve))),
            "Anaerobic": (restingHeartRate + Int(0.7 * Double(heartRateReserve)))...(restingHeartRate + Int(0.8 * Double(heartRateReserve))),
            "Neuromuscular": (restingHeartRate + Int(0.8 * Double(heartRateReserve)))...maxHeartRate
        ]
    }
    
    /// Estimate calorie burn for running based on pace, distance, and weight
    internal static func estimateRunningCalories(
        paceInSeconds: Int,
        distanceInMiles: Double,
        weightInPounds: Double
    ) -> Double {
        // MET (Metabolic Equivalent) calculation
        // Running METs vary by pace - faster = higher MET value
        let paceInMinutesPerMile = Double(paceInSeconds) / 60.0
        
        let met: Double
        switch paceInMinutesPerMile {
        case ..<6.0:    // < 6:00/mile - very fast
            met = 16.0
        case 6.0..<7.0: // 6:00-6:59/mile - fast
            met = 14.0
        case 7.0..<8.0: // 7:00-7:59/mile - moderate-fast
            met = 12.0
        case 8.0..<9.0: // 8:00-8:59/mile - moderate
            met = 10.0
        case 9.0..<10.0: // 9:00-9:59/mile - easy
            met = 8.5
        case 10.0..<12.0: // 10:00-11:59/mile - slow jog
            met = 7.0
        default:         // 12:00+/mile - walking pace
            met = 5.0
        }
        
        // Calories = MET × weight (kg) × time (hours)
        let weightInKg = weightInPounds * 0.453592
        let timeInHours = (paceInMinutesPerMile * distanceInMiles) / 60.0
        
        return met * weightInKg * timeInHours
    }
    
    /// Calculate ideal running cadence based on height
    internal static func calculateIdealCadence(heightInInches: Double) -> Int {
        // General formula: taller runners tend to have slightly lower cadence
        // Base cadence around 180 steps per minute, adjusted for height
        let baselineCadence = 180.0
        let heightAdjustment = (heightInInches - 68.0) * -0.5 // Adjust by height difference from 5'8"
        
        let idealCadence = baselineCadence + heightAdjustment
        return Int(idealCadence.rounded())
    }
    
    /// Convert speed to pace
    internal static func speedToPace(_ speedMph: Double) -> String? {
        guard speedMph > 0 else { return nil }
        
        let minutesPerMile = 60.0 / speedMph
        let minutes = Int(minutesPerMile)
        let seconds = Int((minutesPerMile - Double(minutes)) * 60)
        
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    /// Convert pace to speed
    internal static func paceToSpeed(_ paceString: String) -> Double? {
        guard let paceSeconds = paceString.toSeconds() else { return nil }
        
        let minutesPerMile = Double(paceSeconds) / 60.0
        return 60.0 / minutesPerMile // mph
    }
    
    /// Validate fitness measurements for reasonableness
    internal static func validateMeasurement(
        value: Double,
        type: MeasurementValidationType
    ) -> FitnessConversionError? {
        switch type {
        case .weight(let unit):
            let (min, max) = getWeightRange(for: unit)
            if value < min || value > max {
                return .valueOutOfRange(String(value), validRange: "\(min)-\(max) \(unit.abbreviation)")
            }
            
        case .height(let unit):
            let (min, max) = getHeightRange(for: unit)
            if value < min || value > max {
                return .valueOutOfRange(String(value), validRange: "\(min)-\(max) \(unit.abbreviation)")
            }
            
        case .pace(let seconds):
            // Reasonable pace range: 3:00 to 20:00 per mile
            if seconds < 180 || seconds > 1200 {
                return .valueOutOfRange(String(seconds), validRange: "3:00-20:00 per mile")
            }
            
        case .distance(let unit):
            let (min, max) = getDistanceRange(for: unit)
            if value < min || value > max {
                return .valueOutOfRange(String(value), validRange: "\(min)-\(max) \(unit.abbreviation)")
            }
            
        case .age(let years):
            if years < 1 || years > 120 {
                return .valueOutOfRange(String(years), validRange: "1-120 years")
            }
        }
        
        return nil
    }
    
    /// Get reasonable weight ranges for different units
    private static func getWeightRange(for unit: WeightUnit) -> (min: Double, max: Double) {
        switch unit {
        case .pounds: return (50, 500)      // 50-500 lbs
        case .kilograms: return (20, 250)   // 20-250 kg
        case .stones: return (3, 35)        // 3-35 stones
        }
    }
    
    /// Get reasonable height ranges for different units
    private static func getHeightRange(for unit: HeightUnit) -> (min: Double, max: Double) {
        switch unit {
        case .inches: return (24, 96)       // 2-8 feet
        case .feet: return (2, 8)           // 2-8 feet
        case .centimeters: return (60, 250) // 60-250 cm
        case .meters: return (0.6, 2.5)     // 0.6-2.5 meters
        }
    }
    
    /// Get reasonable distance ranges for different units
    private static func getDistanceRange(for unit: DistanceUnit) -> (min: Double, max: Double) {
        switch unit {
        case .miles: return (0.01, 1000)    // 0.01-1000 miles
        case .kilometers: return (0.01, 1600) // 0.01-1600 km
        case .meters: return (1, 1600000)   // 1m-1600km
        case .yards: return (1, 1750000)    // 1 yard-1000 miles
        case .feet: return (1, 5280000)     // 1 foot-1000 miles
        }
    }
}

// MARK: - Measurement Validation Types

/// Types of measurements that can be validated
internal enum MeasurementValidationType {
    case weight(WeightUnit)
    case height(HeightUnit)
    case pace(Int) // seconds
    case distance(DistanceUnit)
    case age(Int) // years
}

// MARK: - Convenience Extensions

extension FitnessConverter {
    
    /// Quick pace conversion helpers
    public static func milePaceToKmPace(_ milePace: String) -> String? {
        return convertPace(milePace, from: .minutesPerMile, to: .minutesPerKilometer)
    }
    
    public static func kmPaceToMilePace(_ kmPace: String) -> String? {
        return convertPace(kmPace, from: .minutesPerKilometer, to: .minutesPerMile)
    }
    
    /// Quick distance conversion helpers
    public static func milesToKilometers(_ miles: Double) -> Double {
        return convertDistance(miles, from: .miles, to: .kilometers) ?? 0
    }
    
    public static func kilometersToMiles(_ kilometers: Double) -> Double {
        return convertDistance(kilometers, from: .kilometers, to: .miles) ?? 0
    }
    
    /// Quick weight conversion helpers
    public static func poundsToKilograms(_ pounds: Double) -> Double {
        return convertWeight(pounds, from: .pounds, to: .kilograms)
    }
    
    public static func kilogramsToPounds(_ kilograms: Double) -> Double {
        return convertWeight(kilograms, from: .kilograms, to: .pounds)
    }
    
    /// Quick height conversion helpers
    public static func inchesToCentimeters(_ inches: Double) -> Double {
        return convertHeight(inches, from: .inches, to: .centimeters)
    }
    
    public static func centimetersToInches(_ centimeters: Double) -> Double {
        return convertHeight(centimeters, from: .centimeters, to: .inches)
    }
    
    /// Common BMI calculation shortcuts
    public static func calculateBMI_US(weightLbs: Double, heightInches: Double) -> Double? {
        return calculateBMI(weight: weightLbs, height: heightInches, weightUnit: .pounds, heightUnit: .inches)
    }
    
    public static func calculateBMI_Metric(weightKg: Double, heightCm: Double) -> Double? {
        return calculateBMI(weight: weightKg, height: heightCm, weightUnit: .kilograms, heightUnit: .centimeters)
    }
    
}
