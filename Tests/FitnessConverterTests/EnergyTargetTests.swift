//
//  EnergyTargetTests.swift
//  FitnessConverterTests
//
//  Every expected figure here was worked by hand from the formulas, not read back from the code.
//

import XCTest
@testable import FitnessConverter

final class EnergyTargetTests: XCTestCase {

    func testRestingEnergyByMifflinStJeor() {
        // 10 × 82 + 6.25 × 180 − 5 × 34 = 1775; +5 men, −161 women, −78 between.
        XCTAssertEqual(EnergyMath.resting(kilograms: 82, centimetres: 180, age: 34, sex: .male), 1780)
        XCTAssertEqual(EnergyMath.resting(kilograms: 82, centimetres: 180, age: 34, sex: .female), 1614)
        XCTAssertEqual(EnergyMath.resting(kilograms: 82, centimetres: 180, age: 34, sex: .other), 1697)
    }

    func testAWorkedTargetForLosingHalfAKiloAWeek() throws {
        let t = try FitnessConverter.energyTarget(weight: 82, height: 180, weightUnit: .kilograms, heightUnit: .centimeters,
                                                  age: 34, sex: .male, activity: .moderatelyActive, goal: .lose(kilogramsPerWeek: 0.5))
        XCTAssertEqual(t.resting, 1780)
        XCTAssertEqual(t.maintenance, 2759, "1780 × 1.55")
        XCTAssertEqual(t.dailyChange, -550, "0.5 × 7700 / 7")
        XCTAssertEqual(t.calories, 2209)
        XCTAssertFalse(t.raisedToResting)
        XCTAssertEqual(t.proteinGrams, 131, "1.6 × 82")
        XCTAssertEqual(t.fatGrams, 74, "30 % of 2209 kcal / 9")
        XCTAssertEqual(t.carbohydrateGrams, 255, "(2209 − 524.8 − 662.7) / 4")
    }

    func testImperialInputsGiveTheSameTarget() throws {
        // 180.78 lb = 82 kg; 70.866 in = 180 cm.
        let t = try FitnessConverter.energyTarget(weight: 180.779, height: 70.866, weightUnit: .pounds, heightUnit: .inches,
                                                  age: 34, sex: .male, activity: .moderatelyActive, goal: .lose(kilogramsPerWeek: 0.5))
        XCTAssertEqual(t.calories, 2209)
    }

    func testATargetNeverGoesUnderEnergyAtRest() throws {
        // 600 + 1031.25 − 150 − 161 = 1320.25 at rest; × 1.2 = 1584; − 1100 would be 484.
        let t = try FitnessConverter.energyTarget(weight: 60, height: 165, weightUnit: .kilograms, heightUnit: .centimeters,
                                                  age: 30, sex: .female, activity: .sedentary, goal: .lose(kilogramsPerWeek: 1))
        XCTAssertEqual(t.calories, 1320)
        XCTAssertTrue(t.raisedToResting)
    }

    func testMaintainAndGain() throws {
        let keep = try FitnessConverter.energyTarget(weight: 60, height: 165, weightUnit: .kilograms, heightUnit: .centimeters,
                                                     age: 30, sex: .female, activity: .sedentary, goal: .maintain)
        XCTAssertEqual(keep.calories, 1584, "1320.25 × 1.2")
        XCTAssertEqual(keep.dailyChange, 0)
        let gain = try FitnessConverter.energyTarget(weight: 60, height: 165, weightUnit: .kilograms, heightUnit: .centimeters,
                                                     age: 30, sex: .female, activity: .sedentary, goal: .gain(kilogramsPerWeek: 0.25))
        XCTAssertEqual(gain.calories, 1859, "1584.3 + 275")
    }

    func testOutOfRangeInputsAreRefused() {
        func target(age: Int = 30, goal: EnergyGoal = .maintain, weight: Double = 60, fat: Double = 0.3) throws -> EnergyTarget {
            try FitnessConverter.energyTarget(weight: weight, height: 165, weightUnit: .kilograms, heightUnit: .centimeters,
                                              age: age, sex: .female, activity: .sedentary, goal: goal, fatShare: fat)
        }
        XCTAssertThrowsError(try target(age: 15), "the formula is for adults")
        XCTAssertThrowsError(try target(goal: .lose(kilogramsPerWeek: 2)))
        XCTAssertThrowsError(try target(goal: .gain(kilogramsPerWeek: 0)))
        XCTAssertThrowsError(try target(weight: 0))
        XCTAssertThrowsError(try target(fat: 0.6))
    }
}
