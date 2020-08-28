// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MachOParser",
    products: [
        .library(name: "MachOParser", targets: ["MachOParser"]),
        .executable(name: "MachOCLI", targets: ["MachOCLI"]),
        .executable(name: "Demo", targets: ["Demo"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", .upToNextMinor(from: "0.2.0")),
    ],
    targets: [
        .target(name: "MachCore"),
        .target(name: "MachOParser", dependencies: [
            .target(name: "MachCore"),
        ]),
        .target(name: "MachOSwiftParser", dependencies: [
            .target(name: "MachCore"),
            .target(name: "MachOParser"),
        ], linkerSettings: [
            LinkerSetting.linkedLibrary("swiftDemangle"),
        ]),
        .target(name: "MachOEditor", dependencies: [
            .target(name: "MachCore"),
            .target(name: "MachOParser"),
            .target(name: "MachOSwiftParser"),
        ]),
        .target(name: "MachOCLI", dependencies: [
            .target(name: "MachOEditor"),
            .product(name: "ArgumentParser", package: "swift-argument-parser"),
        ]),
        .target(name: "Demo"),
        .testTarget(name: "MachOEditorTests", dependencies: ["MachOEditor"]),
        .testTarget(name: "MachOParserTests", dependencies: ["MachOParser"]),
    ]
)
