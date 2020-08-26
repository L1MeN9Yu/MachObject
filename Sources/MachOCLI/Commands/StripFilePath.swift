//
// Created by Mengyu Li on 2020/8/3.
//

import ArgumentParser
import Foundation
import MachOEditor

struct StripFilePath: ParsableCommand {
    static let configuration: CommandConfiguration = CommandConfiguration(
        abstract: "Strip File Path Strings in Macho File CString "
    )

    @Argument(help: ArgumentHelp(stringLiteral: "macho file path"))
    var macho: String

    @Argument(help: ArgumentHelp(stringLiteral: "file path prefix"))
    var prefix: String

    @Option(name: [.short, .long], help: ArgumentHelp(stringLiteral: "replacement string,default is an empty string"))
    var replacement: String = ""

    @Argument(help: ArgumentHelp(stringLiteral: "output file path"))
    var outputFile: String

    mutating func run() throws {
        let data = try Editor.erase(filePath: [prefix], replacement: replacement, macho: URL(fileURLWithPath: macho))
        try data.write(to: URL(fileURLWithPath: outputFile), options: .atomic)
    }
}
