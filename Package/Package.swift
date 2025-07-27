// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Package",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "AppFeature",
            targets: ["AppFeature"]),
        .library(
            name: "Domain",
            targets: ["Domain"]),
        .library(
            name: "KeySuggestionFeature",
            targets: ["KeySuggestionFeature"]),
        .library(
            name: "SharedModels",
            targets: ["SharedModels"]),
    ],
    targets: [
        .target(
            name: "AppFeature",
            dependencies: [
                "KeySuggestionFeature"
            ]),
        .target(
            name: "Domain",
            dependencies: [
                "SharedModels",
            ]),
        .target(
            name: "KeySuggestionFeature",
            dependencies: [
                "Domain",
                "SharedModels",
            ]),
        .target(
            name: "SharedModels"),
        // Test targets for each module
        .testTarget(
            name: "SharedModelsTests",
            dependencies: [
                "SharedModels"
            ]),
        .testTarget(
            name: "DomainTests",
            dependencies: [
                "Domain",
            ]),
        .testTarget(
            name: "KeySuggestionFeatureTests",
            dependencies: [
                "KeySuggestionFeature",
            ]),
    ]
)
