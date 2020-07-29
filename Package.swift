// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "MachObject",
	products: [
		.library(name: "MachObject", targets: ["MachObject"]),
	],
	dependencies: [],
	targets: [
		.target(name: "MachObject", dependencies: []),
		.testTarget(name: "MachObjectTests", dependencies: ["MachObject"]),
		.target(name: "MachOEditor", dependencies: [.target(name: "MachObject")]),
		.testTarget(name: "MachOEditorTests", dependencies: ["MachOEditor"]),
	]
)
