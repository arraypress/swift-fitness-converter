//
//  Gender.swift
//  FitnessConverter
//
//  Created by David Sherlock on 02/08/2025.
//

import Foundation

/// Gender for fitness calculations
public enum Gender: String, CaseIterable, Sendable {
    case male = "male"
    case female = "female"
    case other = "other"
    
    public var description: String {
        return rawValue.capitalized
    }
}
