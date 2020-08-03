// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "MachObject",
	products: [
		.library(name: "MachObject", targets: ["MachObject"]),
		.executable(name: "MachOCLI", targets: ["MachOCLI"]),
	],
	dependencies: [
		.package(url: "https://github.com/apple/swift-argument-parser", .upToNextMinor(from: "0.2.0")),
	],
	targets: [
		.target(name: "MachObject", dependencies: []),
		.testTarget(name: "MachObjectTests", dependencies: ["MachObject"]),
		.target(name: "MachOEditor", dependencies: [.target(name: "MachObject")]),
		.testTarget(name: "MachOEditorTests", dependencies: ["MachOEditor"]),
		.target(name: "MachOCLI", dependencies: [
			.target(name: "MachOEditor"),
			.product(name: "ArgumentParser", package: "swift-argument-parser"),
		]),
	]
)
