//
//  FitnessConverter+Energy.swift
//  FitnessConverter
//
//  Created by David Sherlock on 2026.
//

import Foundation

extension FitnessConverter {

    /// A daily calorie and macronutrient target from body measurements, activity and a goal.
    ///
    /// ```swift
    /// let target = try FitnessConverter.energyTarget(
    ///     weight: 82, height: 180, weightUnit: .kilograms, heightUnit: .centimeters,
    ///     age: 34, sex: .male, activity: .moderatelyActive, goal: .lose(kilogramsPerWeek: 0.5))
    /// // target.calories 2209 · protein 131 g · fat 74 g · carbohydrate 255 g
    /// ```
    ///
    /// - Parameters:
    ///   - proteinPerKilogram: grams of protein per kilogram of body weight (default 1.6).
    ///   - fatShare: the share of the energy from fat, 0.2–0.35 (default 0.3).
    /// - Returns: The target, never under energy at rest (`raisedToResting` says when it was raised).
    /// - Throws: ``FitnessConversionError/valueOutOfRange(_:validRange:)`` for measurements,
    ///   an age, a rate or shares outside what the formula is for.
    /// - Note: An estimate from published formulas, not a measurement or medical advice.
    public static func energyTarget(
        weight: Double,
        height: Double,
        weightUnit: WeightUnit,
        heightUnit: HeightUnit,
        age: Int,
        sex: Gender,
        activity: ActivityLevel,
        goal: EnergyGoal,
        proteinPerKilogram: Double = 1.6,
        fatShare: Double = 0.3
    ) throws -> EnergyTarget {
        let kilograms = convertWeight(weight, from: weightUnit, to: .kilograms)
        let centimetres = convertHeight(height, from: heightUnit, to: .centimeters)
        guard (25...350).contains(kilograms) else { throw FitnessConversionError.valueOutOfRange("weight \(kilograms) kg", validRange: "25–350 kg") }
        guard (100...250).contains(centimetres) else { throw FitnessConversionError.valueOutOfRange("height \(centimetres) cm", validRange: "100–250 cm") }
        guard (18...100).contains(age) else { throw FitnessConversionError.valueOutOfRange("age \(age)", validRange: "18–100 (the formula is for adults)") }
        switch goal {
        case .lose(let rate), .gain(let rate):
            guard rate > 0 && rate <= 1 else { throw FitnessConversionError.valueOutOfRange("\(rate) kg a week", validRange: "more than 0, at most 1") }
        case .maintain: break
        }
        guard (0.5...3.0).contains(proteinPerKilogram) else { throw FitnessConversionError.valueOutOfRange("protein \(proteinPerKilogram) g/kg", validRange: "0.5–3.0") }
        guard (0.2...0.35).contains(fatShare) else { throw FitnessConversionError.valueOutOfRange("fat share \(fatShare)", validRange: "0.2–0.35") }
        let resting = EnergyMath.resting(kilograms: kilograms, centimetres: centimetres, age: age, sex: sex)
        return EnergyMath.target(resting: resting, multiplier: activity.multiplier, goal: goal, kilograms: kilograms,
                                 proteinPerKilogram: proteinPerKilogram, fatShare: fatShare)
    }
}
