//
// Created by Mengyu Li on 2020/8/3.
//

import ArgumentParser
import Foundation

struct Command: ParsableCommand {
	static let configuration: CommandConfiguration = CommandConfiguration(
		abstract: "MachO CLI",
		discussion: "The MachO Tool",
		version: "0.0.1",
		shouldDisplay: false,
		subcommands: [Info.self, StripFilePath.self, ReplaceString.self],
		defaultSubcommand: Info.self
	)
}
