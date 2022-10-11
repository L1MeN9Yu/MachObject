// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MachObject",
    products: [
        .library(name: "MachOParser", targets: ["MachOParser"]),
        .library(name: "CodeSignParser", targets: ["CodeSignParser"]),
        .executable(name: "MachOCLI", targets: ["MachOCLI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.5.0"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.4.4"),
        .package(url: "https://github.com/L1MeN9Yu/Senna.git", from: "2.5.0"),
    ],
    targets: [
        .target(name: "MachCore"),
        .target(name: "MachLog", dependencies: [
            .product(name: "Logging", package: "swift-log"),
            .product(name: "Senna", package: "Senna"),
        ]),
        .target(name: "Measure", dependencies: [
            .target(name: "MachLog"),
        ]),
        .target(name: "CodeSignParser", dependencies: [
            .target(name: "MachCore"),
        ]),
        .target(name: "MachOParser", dependencies: [
            .target(name: "MachCore"),
            .target(name: "CodeSignParser"),
        ]),
        .target(name: "MachOObjcParser", dependencies: [
            .target(name: "MachCore"),
            .target(name: "MachOParser"),
        ]),
        .target(name: "ObjCObfuscation", dependencies: [
            .target(name: "MachCore"),
            .target(name: "MachOParser"),
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
            .target(name: "MachOObjcParser"),
            .target(name: "ObjCObfuscation"),
            .target(name: "MachLog"),
        ]),
        .target(name: "MachOCLI", dependencies: [
            .target(name: "MachOParser"),
            .target(name: "MachOEditor"),
            .product(name: "ArgumentParser", package: "swift-argument-parser"),
        ]),
        .testTarget(name: "MachOEditorTests", dependencies: ["MachOEditor"]),
        .testTarget(name: "MachOParserTests", dependencies: ["MachOParser"]),
    ]
)
