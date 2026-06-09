# Swift Fitness Converter

A comprehensive Swift package for fitness measurement conversions and health calculations. Convert running pace, distance, weight, and height between metric and imperial units, calculate BMI, and inspect conversions with confidence scores and helpful notes — perfect for fitness apps, health platforms, and international workout tracking.

## Features

- 🏃 **Pace conversion** — Convert running/walking pace between minutes-per-mile and minutes-per-kilometer, with `String` ("7:30"), `Int`, and `Double` inputs.
- ⚖️ **BMI calculation** — Compute Body Mass Index from any mix of weight and height units, returning WHO-standard category context.
- 📏 **Distance conversion** — Miles, kilometers, meters, yards, and feet with high-precision metre-based math.
- 🏋️ **Weight conversion** — Pounds, kilograms, and stones.
- 📐 **Height conversion** — Inches, feet, centimeters, and meters.
- 📊 **Detailed results** — `convertPaceWithDetails` and `calculateBMIWithDetails` return confidence scores, notes, and error context.
- 🎯 **Confidence scoring** — Every detailed result carries a reliability score from 0.0 to 1.0.
- 🌍 **International support** — Built for both US Imperial and Metric systems.
- 🧩 **Generic pace API** — `PaceConvertible` lets pace flow through your preferred numeric or string type.
- 🛡️ **Typed errors** — `FitnessConversionError` with user-friendly descriptions for invalid input.
- 🔍 **Capability introspection** — `conversionInfo()` reports supported units and calculations for building UIs.
- 🧱 **Sendable throughout** — All public types are `Sendable` for safe concurrency.

## Requirements

- iOS 13.0+ / macOS 10.15+ / tvOS 13.0+ / watchOS 6.0+
- Swift 6.1+
- Xcode 16.0+

## Installation

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/arraypress/swift-fitness-converter.git", from: "1.0.0")
]
```

## Usage

### Converting pace

```swift
import FitnessConverter

// String pace in mm:ss
let kmPace = FitnessConverter.convertPace(
    "7:30",
    from: .minutesPerMile,
    to: .minutesPerKilometer
)
// "4:39"

// Detailed result with confidence and notes
let result = FitnessConverter.convertPaceWithDetails(
    "7:30",
    from: .minutesPerMile,
    to: .minutesPerKilometer
)
print(result.convertedPace ?? "N/A")
print(result.confidence)   // 1.0
print(result.notes ?? "")  // "Equivalent to ... mph"
```

### Calculating BMI

```swift
import FitnessConverter

// US units
let bmi = FitnessConverter.calculateBMI(
    weight: 150,
    height: 68,
    weightUnit: .pounds,
    heightUnit: .inches
)
// 22.8

// Metric units, with health category
let detailed = FitnessConverter.calculateBMIWithDetails(
    weight: 70,
    height: 175,
    weightUnit: .kilograms,
    heightUnit: .centimeters
)
print(detailed.calculatedValue ?? 0)  // 22.9
print(detailed.notes ?? "")           // "BMI Category: Normal weight"
```

### Converting distance, weight, and height

```swift
import FitnessConverter

FitnessConverter.convertDistance(26.2, from: .miles, to: .kilometers)  // ~42.16
FitnessConverter.convertWeight(150, from: .pounds, to: .kilograms)     // ~68.04
FitnessConverter.convertHeight(68, from: .inches, to: .centimeters)    // ~172.72
```

### Inspecting capabilities

```swift
import FitnessConverter

let info = FitnessConverter.conversionInfo()
print(info.supportedCalculations.count)
print(info.distanceUnits.count)
```

## Models

| Type | Description |
|------|-------------|
| `FitnessConversionResult<T>` | Conversion outcome with `convertedPace`, `calculatedValue`, units, `confidence`, `notes`, and optional `error`. |
| `FitnessConversionInfo` | Supported calculations and unit lists, plus derived helpers like `totalUnitConversions`. |
| `FitnessProfile` | Optional age, gender, activity level, and resting heart rate. |
| `AnyFitnessUnit` | Type-erased unit wrapper used inside results. |
| `DistanceUnit` | `.miles`, `.kilometers`, `.meters`, `.yards`, `.feet`. |
| `WeightUnit` | `.pounds`, `.kilograms`, `.stones`. |
| `HeightUnit` | `.inches`, `.feet`, `.centimeters`, `.meters`. |
| `PaceUnit` | `.minutesPerMile`, `.minutesPerKilometer`. |
| `CalculationType` | `.paceConversion`, `.bmi`, `.distance`, `.weight`, `.height`, `.calories`, `.heartRate`. |
| `ActivityLevel` | `.sedentary` … `.extraActive`, each with a `multiplier`. |
| `Gender` | `.male`, `.female`, `.other`. |
| `FitnessConversionError` | Typed errors with `userFriendlyDescription`. |

## How It Works

Conversions normalize through a base unit (metres for distance/height, kilograms for weight) for consistent, lossless math. BMI uses the standard formula `weight (kg) / height (m)²`, rounded to one decimal, with WHO-standard category classification. Pace conversions translate to total seconds, scale by the distance ratio between units, and reformat to the original input type via the `PaceConvertible` protocol.

## Testing

```bash
swift test
```

The test suite covers pace, BMI, distance, weight, and height conversions along with error handling and capability introspection.

## License

MIT License — see LICENSE file for details.

## Author

Created by David Sherlock ([ArrayPress](https://github.com/arraypress)) in 2026.
