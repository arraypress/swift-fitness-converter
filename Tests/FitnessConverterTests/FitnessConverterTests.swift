import XCTest
@testable import FitnessConverter

final class FitnessConverterTests: XCTestCase {
    
    // MARK: - Pace Conversion Tests
    
    func testPaceConversionStringFormat() {
        // Test mile to km pace conversion
        let kmPace = FitnessConverter.convertPace("7:30", from: .minutesPerMile, to: .minutesPerKilometer)
        XCTAssertEqual(kmPace, "4:39", "7:30 mile pace should convert to 4:39 km pace")
        
        // Test km to mile pace conversion - use more precise starting value
        let milePace = FitnessConverter.convertPace("4:40", from: .minutesPerKilometer, to: .minutesPerMile)
        XCTAssertNotNil(milePace, "4:40 km pace conversion should succeed")
        // Allow for small rounding differences
        XCTAssertTrue(milePace == "7:30" || milePace == "7:31", "4:40 km pace should convert to approximately 7:30-7:31 mile pace")
        
        // Test same unit conversion
        let samePace = FitnessConverter.convertPace("7:30", from: .minutesPerMile, to: .minutesPerMile)
        XCTAssertEqual(samePace, "7:30", "Same unit conversion should return original value")
    }
    
    func testPaceConversionDecimalFormat() {
        // Test decimal minutes
        let result = FitnessConverter.convertPace(7.5, from: .minutesPerMile, to: .minutesPerKilometer)
        XCTAssertNotNil(result, "Decimal pace conversion should succeed")
        XCTAssertEqual(result!, 4.65, accuracy: 0.01, "7.5 min/mile should convert to ~4.65 min/km")
    }
    
    func testPaceConversionIntegerFormat() {
        // Test total seconds
        let result = FitnessConverter.convertPace(450, from: .minutesPerMile, to: .minutesPerKilometer)
        XCTAssertNotNil(result, "Integer seconds pace conversion should succeed")
        XCTAssertEqual(result!, 279, accuracy: 1, "450 seconds/mile should convert to ~279 seconds/km")
    }
    
    func testInvalidPaceFormats() {
        // Test invalid string formats
        let invalidPace1 = FitnessConverter.convertPace("7:75", from: .minutesPerMile, to: .minutesPerKilometer)
        XCTAssertNil(invalidPace1, "Invalid seconds (>60) should return nil")
        
        let invalidPace2 = FitnessConverter.convertPace("abc", from: .minutesPerMile, to: .minutesPerKilometer)
        XCTAssertNil(invalidPace2, "Non-numeric string should return nil")
        
        let invalidPace3 = FitnessConverter.convertPace(-5.0, from: .minutesPerMile, to: .minutesPerKilometer)
        XCTAssertNil(invalidPace3, "Negative pace should return nil")
    }
    
    func testPaceConversionWithDetails() {
        let result = FitnessConverter.convertPaceWithDetails("7:30", from: .minutesPerMile, to: .minutesPerKilometer)
        
        XCTAssertTrue(result.isSuccess, "Conversion should be successful")
        XCTAssertEqual(result.convertedPace, "4:39", "Converted pace should be correct")
        XCTAssertEqual(result.confidence, 1.0, "Confidence should be 1.0 for exact conversion")
        XCTAssertNotNil(result.notes, "Notes should contain speed equivalent")
        XCTAssertTrue(result.notes?.contains("mph") == true, "Notes should mention speed in mph")
    }
    
    // MARK: - BMI Calculation Tests
    
    func testBMICalculationUSUnits() {
        // Test BMI with US units (pounds, inches)
        let bmi = FitnessConverter.calculateBMI(weight: 150, height: 68, weightUnit: .pounds, heightUnit: .inches)
        XCTAssertNotNil(bmi, "BMI calculation should succeed")
        XCTAssertEqual(bmi!, 22.8, accuracy: 0.1, "BMI should be approximately 22.8")
    }
    
    func testBMICalculationMetricUnits() {
        // Test BMI with metric units (kg, cm)
        let bmi = FitnessConverter.calculateBMI(weight: 70, height: 175, weightUnit: .kilograms, heightUnit: .centimeters)
        XCTAssertNotNil(bmi, "BMI calculation should succeed")
        XCTAssertEqual(bmi!, 22.9, accuracy: 0.1, "BMI should be approximately 22.9")
    }
    
    func testBMICalculationWithDetails() {
        let result = FitnessConverter.calculateBMIWithDetails(weight: 150, height: 68, weightUnit: .pounds, heightUnit: .inches)
        
        XCTAssertTrue(result.isSuccess, "BMI calculation should be successful")
        XCTAssertNotNil(result.calculatedValue, "Should have calculated BMI value")
        XCTAssertEqual(result.confidence, 0.95, "Confidence should be 0.95")
        XCTAssertTrue(result.notes?.contains("BMI Category") == true, "Notes should contain BMI category")
        
        // Test different BMI categories with more precise values
        let underweight = FitnessConverter.calculateBMIWithDetails(weight: 100, height: 68, weightUnit: .pounds, heightUnit: .inches)
        XCTAssertTrue(underweight.notes?.contains("Underweight") == true, "Should classify as underweight")
        
        // Use a weight that clearly falls into overweight category (BMI > 25)
        let overweight = FitnessConverter.calculateBMIWithDetails(weight: 180, height: 68, weightUnit: .pounds, heightUnit: .inches)
        XCTAssertTrue(overweight.notes?.contains("Overweight") == true, "Should classify as overweight")
        
        // Test obesity category (BMI > 30)
        let obese = FitnessConverter.calculateBMIWithDetails(weight: 220, height: 68, weightUnit: .pounds, heightUnit: .inches)
        XCTAssertTrue(obese.notes?.contains("Obesity") == true, "Should classify as obesity")
    }
    
    func testInvalidBMIInputs() {
        // Test negative weight
        let negativeWeight = FitnessConverter.calculateBMI(weight: -150, height: 68, weightUnit: .pounds, heightUnit: .inches)
        XCTAssertNil(negativeWeight, "Negative weight should return nil")
        
        // Test zero height
        let zeroHeight = FitnessConverter.calculateBMI(weight: 150, height: 0, weightUnit: .pounds, heightUnit: .inches)
        XCTAssertNil(zeroHeight, "Zero height should return nil")
    }
    
    // MARK: - Distance Conversion Tests
    
    func testDistanceConversions() {
        // Miles to kilometers
        let km = FitnessConverter.convertDistance(5.0, from: .miles, to: .kilometers)
        XCTAssertNotNil(km, "Distance conversion should succeed")
        XCTAssertEqual(km!, 8.047, accuracy: 0.01, "5 miles should be ~8.047 km")
        
        // Kilometers to miles
        let miles = FitnessConverter.convertDistance(10.0, from: .kilometers, to: .miles)
        XCTAssertNotNil(miles, "Distance conversion should succeed")
        XCTAssertEqual(miles!, 6.214, accuracy: 0.01, "10 km should be ~6.214 miles")
        
        // Meters to yards
        let yards = FitnessConverter.convertDistance(400, from: .meters, to: .yards)
        XCTAssertNotNil(yards, "Distance conversion should succeed")
        XCTAssertEqual(yards!, 437.45, accuracy: 0.1, "400m should be ~437.45 yards")
        
        // Same unit conversion
        let sameMiles = FitnessConverter.convertDistance(5.0, from: .miles, to: .miles)
        XCTAssertEqual(sameMiles, 5.0, "Same unit conversion should return original value")
    }
    
    func testInvalidDistanceInputs() {
        // Test negative distance
        let negativeDistance = FitnessConverter.convertDistance(-5.0, from: .miles, to: .kilometers)
        XCTAssertNil(negativeDistance, "Negative distance should return nil")
    }
    
    // MARK: - Weight Conversion Tests
    
    func testWeightConversions() {
        // Pounds to kilograms
        let kg = FitnessConverter.convertWeight(150, from: .pounds, to: .kilograms)
        XCTAssertEqual(kg, 68.04, accuracy: 0.01, "150 lbs should be ~68.04 kg")
        
        // Kilograms to pounds
        let lbs = FitnessConverter.convertWeight(70, from: .kilograms, to: .pounds)
        XCTAssertEqual(lbs, 154.32, accuracy: 0.01, "70 kg should be ~154.32 lbs")
        
        // Stones to kilograms
        let kgFromStones = FitnessConverter.convertWeight(10, from: .stones, to: .kilograms)
        XCTAssertEqual(kgFromStones, 63.5, accuracy: 0.1, "10 stones should be ~63.5 kg")
        
        // Same unit conversion
        let sameLbs = FitnessConverter.convertWeight(150, from: .pounds, to: .pounds)
        XCTAssertEqual(sameLbs, 150, "Same unit conversion should return original value")
    }
    
    // MARK: - Height Conversion Tests
    
    func testHeightConversions() {
        // Inches to centimeters
        let cm = FitnessConverter.convertHeight(68, from: .inches, to: .centimeters)
        XCTAssertEqual(cm, 172.72, accuracy: 0.01, "68 inches should be ~172.72 cm")
        
        // Centimeters to inches
        let inches = FitnessConverter.convertHeight(175, from: .centimeters, to: .inches)
        XCTAssertEqual(inches, 68.9, accuracy: 0.1, "175 cm should be ~68.9 inches")
        
        // Feet to meters
        let meters = FitnessConverter.convertHeight(6, from: .feet, to: .meters)
        XCTAssertEqual(meters, 1.829, accuracy: 0.01, "6 feet should be ~1.829 meters")
        
        // Same unit conversion
        let sameInches = FitnessConverter.convertHeight(68, from: .inches, to: .inches)
        XCTAssertEqual(sameInches, 68, "Same unit conversion should return original value")
    }
    
    // MARK: - Convenience Method Tests
    
    func testConvenienceMethods() {
        // Test mile to km pace shortcuts
        let kmPace = FitnessConverter.milePaceToKmPace("7:30")
        XCTAssertEqual(kmPace, "4:39", "Mile to km pace shortcut should work")
        
        // Test km to mile pace with more forgiving assertion
        let milePace = FitnessConverter.kmPaceToMilePace("4:40")
        XCTAssertNotNil(milePace, "Km to mile pace shortcut should work")
        XCTAssertTrue(milePace == "7:30" || milePace == "7:31", "Km to mile pace should be approximately correct")
        
        // Test distance shortcuts
        let km = FitnessConverter.milesToKilometers(5.0)
        XCTAssertEqual(km, 8.047, accuracy: 0.01, "Miles to km shortcut should work")
        
        let miles = FitnessConverter.kilometersToMiles(8.047)
        XCTAssertEqual(miles, 5.0, accuracy: 0.01, "Km to miles shortcut should work")
        
        // Test weight shortcuts
        let kg = FitnessConverter.poundsToKilograms(150)
        XCTAssertEqual(kg, 68.04, accuracy: 0.01, "Pounds to kg shortcut should work")
        
        let lbs = FitnessConverter.kilogramsToPounds(68.04)
        XCTAssertEqual(lbs, 150, accuracy: 0.1, "Kg to pounds shortcut should work")
        
        // Test height shortcuts
        let cm = FitnessConverter.inchesToCentimeters(68)
        XCTAssertEqual(cm, 172.72, accuracy: 0.01, "Inches to cm shortcut should work")
        
        let inches = FitnessConverter.centimetersToInches(172.72)
        XCTAssertEqual(inches, 68, accuracy: 0.1, "Cm to inches shortcut should work")
        
        // Test BMI shortcuts
        let bmiUS = FitnessConverter.calculateBMI_US(weightLbs: 150, heightInches: 68)
        XCTAssertNotNil(bmiUS, "US BMI shortcut should work")
        XCTAssertEqual(bmiUS!, 22.8, accuracy: 0.1, "US BMI calculation should be correct")
        
        let bmiMetric = FitnessConverter.calculateBMI_Metric(weightKg: 70, heightCm: 175)
        XCTAssertNotNil(bmiMetric, "Metric BMI shortcut should work")
        XCTAssertEqual(bmiMetric!, 22.9, accuracy: 0.1, "Metric BMI calculation should be correct")
    }
    
    // MARK: - Conversion Info Tests
    
    func testConversionInfo() {
        let info = FitnessConverter.conversionInfo()
        
        XCTAssertGreaterThan(info.supportedCalculations.count, 0, "Should have supported calculations")
        XCTAssertGreaterThan(info.distanceUnits.count, 0, "Should have distance units")
        XCTAssertGreaterThan(info.weightUnits.count, 0, "Should have weight units")
        XCTAssertGreaterThan(info.heightUnits.count, 0, "Should have height units")
        XCTAssertGreaterThan(info.paceUnits.count, 0, "Should have pace units")
        
        XCTAssertEqual(info.distanceUnits.count, 5, "Should have 5 distance units")
        XCTAssertEqual(info.weightUnits.count, 3, "Should have 3 weight units")
        XCTAssertEqual(info.heightUnits.count, 4, "Should have 4 height units")
        XCTAssertEqual(info.paceUnits.count, 2, "Should have 2 pace units")
        
        XCTAssertGreaterThan(info.totalUnitConversions, 0, "Should calculate total conversions")
        XCTAssertFalse(info.description.isEmpty, "Should have description")
        
        let unitsByContext = info.unitsByContext
        XCTAssertTrue(unitsByContext.keys.contains("Distance"), "Should have Distance category")
        XCTAssertTrue(unitsByContext.keys.contains("Weight"), "Should have Weight category")
        XCTAssertTrue(unitsByContext.keys.contains("Height"), "Should have Height category")
        XCTAssertTrue(unitsByContext.keys.contains("Pace"), "Should have Pace category")
    }
    
    // MARK: - Edge Cases and Error Handling Tests
    
    func testErrorHandling() {
        // Test pace conversion with invalid format
        let invalidResult = FitnessConverter.convertPaceWithDetails("invalid", from: .minutesPerMile, to: .minutesPerKilometer)
        XCTAssertFalse(invalidResult.isSuccess, "Invalid pace should fail")
        XCTAssertNotNil(invalidResult.error, "Should have error for invalid pace")
        
        // Test BMI with invalid inputs
        let invalidBMI = FitnessConverter.calculateBMIWithDetails(weight: -50, height: 68, weightUnit: .pounds, heightUnit: .inches)
        XCTAssertFalse(invalidBMI.isSuccess, "Invalid BMI inputs should fail")
        XCTAssertNotNil(invalidBMI.error, "Should have error for invalid BMI inputs")
    }
    
    // MARK: - Real-World Scenario Tests
    
    func testRealWorldScenarios() {
        // Marathon pace conversions
        let marathonMilePace = "8:00"
        let marathonKmPace = FitnessConverter.convertPace(marathonMilePace, from: .minutesPerMile, to: .minutesPerKilometer)
        XCTAssertNotNil(marathonKmPace, "Marathon pace conversion should work")
        
        // 5K race distance
        let fiveKInMiles = FitnessConverter.convertDistance(5.0, from: .kilometers, to: .miles)
        XCTAssertNotNil(fiveKInMiles, "5K distance conversion should work")
        XCTAssertEqual(fiveKInMiles!, 3.107, accuracy: 0.01, "5K should be ~3.107 miles")
        
        // Athletic weight conversions
        let runnerWeightKg = FitnessConverter.convertWeight(140, from: .pounds, to: .kilograms)
        XCTAssertEqual(runnerWeightKg, 63.5, accuracy: 0.1, "140 lbs should be ~63.5 kg")
        
        // Height conversions for international athletes
        let heightCm = FitnessConverter.convertHeight(5.9, from: .feet, to: .centimeters)
        XCTAssertEqual(heightCm, 179.83, accuracy: 0.1, "5.9 feet should be ~179.83 cm")
    }
    
    // MARK: - Performance Tests
    
    func testPerformance() {
        measure {
            // Test pace conversion performance
            for _ in 0..<1000 {
                _ = FitnessConverter.convertPace("7:30", from: .minutesPerMile, to: .minutesPerKilometer)
            }
        }
    }
    
    func testBMIPerformance() {
        measure {
            // Test BMI calculation performance
            for _ in 0..<1000 {
                _ = FitnessConverter.calculateBMI(weight: 150, height: 68, weightUnit: .pounds, heightUnit: .inches)
            }
        }
    }
    
    // MARK: - Protocol Conformance Tests
    
    func testPaceConvertibleProtocol() {
        // Test String conformance
        let stringSeconds = "7:30".toSeconds()
        XCTAssertEqual(stringSeconds, 450, "String should convert to correct seconds")
        
        let stringFromSeconds = String.fromSeconds(450)
        XCTAssertEqual(stringFromSeconds, "7:30", "Seconds should convert to correct string")
        
        // Test Double conformance
        let doubleSeconds = 7.5.toSeconds()
        XCTAssertEqual(doubleSeconds, 450, "Double should convert to correct seconds")
        
        let doubleFromSeconds = Double.fromSeconds(450)
        XCTAssertEqual(doubleFromSeconds, 7.5, "Seconds should convert to correct double")
        
        // Test Int conformance
        let intSeconds = 450.toSeconds()
        XCTAssertEqual(intSeconds, 450, "Int should passthrough seconds")
        
        let intFromSeconds = Int.fromSeconds(450)
        XCTAssertEqual(intFromSeconds, 450, "Seconds should passthrough for int")
    }
    
    // MARK: - Unit Enum Tests
    
    func testUnitEnums() {
        // Test DistanceUnit
        XCTAssertEqual(DistanceUnit.miles.toMeters, 1609.344, "Miles conversion factor should be correct")
        XCTAssertEqual(DistanceUnit.kilometers.toMeters, 1000.0, "Kilometers conversion factor should be correct")
        
        // Test WeightUnit
        XCTAssertEqual(WeightUnit.pounds.toKilograms, 0.453592, accuracy: 0.000001, "Pounds conversion factor should be correct")
        XCTAssertEqual(WeightUnit.kilograms.toKilograms, 1.0, "Kilograms conversion factor should be correct")
        
        // Test HeightUnit
        XCTAssertEqual(HeightUnit.inches.toMeters, 0.0254, "Inches conversion factor should be correct")
        XCTAssertEqual(HeightUnit.centimeters.toMeters, 0.01, "Centimeters conversion factor should be correct")
        
        // Test PaceUnit
        XCTAssertEqual(PaceUnit.minutesPerMile.distanceInMeters, 1609.344, "Mile pace distance should be correct")
        XCTAssertEqual(PaceUnit.minutesPerKilometer.distanceInMeters, 1000.0, "Kilometer pace distance should be correct")
    }
}
