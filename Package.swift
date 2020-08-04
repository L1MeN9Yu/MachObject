// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "MachOParser",
	products: [
		.library(name: "MachOParser", targets: ["MachOParser"]),
		.executable(name: "MachOCLI", targets: ["MachOCLI"]),
	],
	dependencies: [
		.package(url: "https://github.com/apple/swift-argument-parser", .upToNextMinor(from: "0.2.0")),
	],
	targets: [
		.target(name: "MachOParser", dependencies: []),
		.testTarget(name: "MachOParserTests", dependencies: ["MachOParser"]),
		.target(name: "MachOEditor", dependencies: [.target(name: "MachOParser")]),
		.testTarget(name: "MachOEditorTests", dependencies: ["MachOEditor"]),
		.target(name: "MachOCLI", dependencies: [
			.target(name: "MachOEditor"),
			.product(name: "ArgumentParser", package: "swift-argument-parser"),
		]),
	]
)
