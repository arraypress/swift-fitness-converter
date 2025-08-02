//
//  FitnessUnitProtocol.swift
//  FitnessConverter
//
//  Created by David Sherlock on 02/08/2025.
//

import Foundation

/// Protocol that all fitness unit types conform to.
public protocol FitnessUnitProtocol {
    var fullName: String { get }
    var abbreviation: String { get }
}

extension DistanceUnit: FitnessUnitProtocol {}
extension WeightUnit: FitnessUnitProtocol {}
extension HeightUnit: FitnessUnitProtocol {}
extension PaceUnit: FitnessUnitProtocol {}
