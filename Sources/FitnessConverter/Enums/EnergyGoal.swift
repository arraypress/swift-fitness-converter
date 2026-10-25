//
//  EnergyGoal.swift
//  FitnessConverter
//
//  Created by David Sherlock on 2026.
//

import Foundation

/// What a daily energy target is for: losing, keeping or gaining weight, at a rate in
/// kilograms per week.
public enum EnergyGoal: Equatable, Sendable {
    /// Lose this many kilograms a week (at most 1).
    case lose(kilogramsPerWeek: Double)
    /// Stay at the current weight.
    case maintain
    /// Gain this many kilograms a week (at most 1).
    case gain(kilogramsPerWeek: Double)
}
