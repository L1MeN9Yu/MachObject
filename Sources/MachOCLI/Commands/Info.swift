//
// Created by Mengyu Li on 2020/8/3.
//

import ArgumentParser
import Foundation
import MachObject

struct Info: ParsableCommand {
	static let configuration: CommandConfiguration = CommandConfiguration(abstract: "Show Macho File Information")

	@Argument(help: "mach file path")
	var macho: String

	mutating func run() throws {
		let fileURL = URL(fileURLWithPath: macho)
		let image = try Image.load(url: fileURL)
		print("\(image)")
	}
}
