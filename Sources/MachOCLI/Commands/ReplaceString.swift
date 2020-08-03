//
// Created by Mengyu Li on 2020/8/3.
//

import ArgumentParser
import Foundation
import MachObject
import MachOEditor

struct ReplaceString: ParsableCommand {
	static let configuration: CommandConfiguration = CommandConfiguration(abstract: "Replace Strings in Macho File CString ")

	@Argument(help: ArgumentHelp(stringLiteral: "macho file path"))
	var macho: String

	@Argument(help: ArgumentHelp(stringLiteral: "the string need to be replaced"))
	var keyword: String

	@Argument(help: ArgumentHelp(stringLiteral: "the replacement string"))
	var replacement: String

	@Argument(help: ArgumentHelp(stringLiteral: "output file path"))
	var outputFile: String

	mutating func run() throws {}
}
