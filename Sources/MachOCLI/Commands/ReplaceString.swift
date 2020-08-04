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

	@Flag(help: "Replace Whole String")
	var whole: Bool = false

	mutating func run() throws {
		let replaceStyle: ReplaceStyle = whole ? .wholeString : .onlyKeyword
		let data = try Editor.replace(
			keyword: keyword, replacement: replacement,
			replaceStyle: replaceStyle, macho: URL(fileURLWithPath: macho)
		)
		try data.write(to: URL(fileURLWithPath: outputFile), options: .atomic)
	}
}
