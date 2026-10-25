//
//  EnergyTarget.swift
//  FitnessConverter
//
//  Created by David Sherlock on 2026.
//

import Foundation

/// A daily energy and macronutrient target, with the steps it was built from.
/// Energies are kilocalories a day, macronutrients grams a day, all whole numbers.
public struct EnergyTarget: Equatable, Sendable {
    /// Energy at rest (Mifflin–St Jeor).
    public let resting: Double
    /// Energy to keep the current weight: resting × the activity multiplier.
    public let maintenance: Double
    /// The change the goal asks for: negative to lose, positive to gain.
    public let dailyChange: Double
    /// What to eat a day.
    public let calories: Double
    /// True when the goal would have put `calories` under `resting`, and it was raised to it.
    public let raisedToResting: Bool
    public let proteinGrams: Double
    public let fatGrams: Double
    public let carbohydrateGrams: Double
}
