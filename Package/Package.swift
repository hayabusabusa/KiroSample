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
            name: "HomeFeature",
            targets: ["HomeFeature"]),
        .library(
            name: "SettingsFeature",
            targets: ["SettingsFeature"]),
        .library(
            name: "SharedExtensions",
            targets: ["SharedExtensions"]),
        .library(
            name: "SharedModels",
            targets: ["SharedModels"]),
    ],
    targets: [
        .target(
            name: "AppFeature",
            dependencies: [
                "Domain",
                "HomeFeature",
                "SettingsFeature",
            ]),
        .target(
            name: "Domain",
            dependencies: [
                "SharedModels"
            ]),
        .target(
            name: "HomeFeature",
            dependencies: [
                "Domain",
                "SharedExtensions",
                "SharedModels",
            ]),
        .target(
            name: "SettingsFeature",
            dependencies: [
                "SharedExtensions",
                "SharedModels",
            ]),
        .target(
            name: "SharedExtensions",
            dependencies: []),
        .target(
            name: "SharedModels",
            dependencies: []),
        .testTarget(
            name: "PackageTests",
            dependencies: [
                "HomeFeature",
                "SettingsFeature",
            ]
        ),
    ]
)
