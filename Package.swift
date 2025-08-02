// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FitnessConverter",  // Package name
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        .library(
            name: "FitnessConverter",  // What you import
            targets: ["FitnessConverter"]),
    ],
    targets: [
        .target(
            name: "FitnessConverter"),  // Target/module name
        .testTarget(
            name: "FitnessConverterTests",
            dependencies: ["FitnessConverter"]),
    ]
)
