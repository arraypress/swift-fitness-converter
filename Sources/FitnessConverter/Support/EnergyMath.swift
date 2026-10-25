//
//  EnergyMath.swift
//  FitnessConverter
//
//  Created by David Sherlock on 2026.
//
//  Daily energy from body measurements. Every figure here is a published convention, not
//  a measurement of anyone: Mifflin–St Jeor (1990) for energy at rest, the usual activity
//  multipliers (ActivityLevel), ~7,700 kcal per kilogram of body weight, and a fat share
//  inside the 20–35 % range most dietary guidelines give. An estimate to start from.
//

import Foundation

/// The pure arithmetic behind ``FitnessConverter/energyTarget(weight:height:weightUnit:heightUnit:age:sex:activity:goal:proteinPerKilogram:fatShare:)``.
enum EnergyMath {

    /// Kilocalories in a kilogram of body weight gained or lost.
    static let caloriesPerKilogram = 7_700.0

    /// Energy at rest, kcal/day (Mifflin–St Jeor): 10 × kg + 6.25 × cm − 5 × years, then
    /// +5 for men and −161 for women. `other` takes the midpoint of the two, −78.
    static func resting(kilograms: Double, centimetres: Double, age: Int, sex: Gender) -> Double {
        let base = 10 * kilograms + 6.25 * centimetres - 5 * Double(age)
        switch sex {
        case .male: return base + 5
        case .female: return base - 161
        case .other: return base - 78
        }
    }

    /// The daily change a goal asks for, kcal/day: the weekly rate in energy, spread over 7 days.
    static func dailyChange(for goal: EnergyGoal) -> Double {
        switch goal {
        case .lose(let rate): return -rate * caloriesPerKilogram / 7
        case .maintain: return 0
        case .gain(let rate): return rate * caloriesPerKilogram / 7
        }
    }

    /// The target, never under energy at rest; protein by body weight, fat as a share of the
    /// energy, carbohydrate the rest (4, 9 and 4 kcal per gram).
    static func target(resting: Double, multiplier: Double, goal: EnergyGoal, kilograms: Double,
                       proteinPerKilogram: Double, fatShare: Double) -> EnergyTarget {
        let maintenance = resting * multiplier
        let change = dailyChange(for: goal)
        let wanted = maintenance + change
        let calories = max(wanted, resting)
        let protein = proteinPerKilogram * kilograms
        let fat = calories * fatShare / 9
        let carbohydrate = max(0, (calories - protein * 4 - fat * 9) / 4)
        return EnergyTarget(resting: resting.rounded(), maintenance: maintenance.rounded(), dailyChange: change.rounded(),
                            calories: calories.rounded(), raisedToResting: wanted < resting,
                            proteinGrams: protein.rounded(), fatGrams: fat.rounded(), carbohydrateGrams: carbohydrate.rounded())
    }
}
