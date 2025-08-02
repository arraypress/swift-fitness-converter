//
//  AnyFitnessUnit.swift
//  FitnessConverter
//
//  Created by David Sherlock on 02/08/2025.
//

import Foundation

/// Type-erased container for different fitness unit types.
///
/// Used internally to handle different unit types in a uniform way
/// while maintaining type safety in the public API.
public struct AnyFitnessUnit: Sendable {
    public let name: String
    public let abbreviation: String
    public let unitType: String
    
    public init<T: FitnessUnitProtocol>(_ unit: T) {
        self.name = unit.fullName
        self.abbreviation = unit.abbreviation
        self.unitType = String(describing: type(of: unit))
    }
}
