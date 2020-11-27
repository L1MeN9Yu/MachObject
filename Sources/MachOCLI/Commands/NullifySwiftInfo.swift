//
// Created by Mengyu Li on 2020/11/27.
//

import ArgumentParser
import Foundation
import MachOEditor

struct NullifySwiftInfo: ParsableCommand {
    @Argument(help: ArgumentHelp(stringLiteral: "macho file path"))
    var macho: String

    @Argument(help: ArgumentHelp(stringLiteral: "output file path"))
    var outputFile: String

    func run() throws {
        let data = try Editor.eraseSwiftInfos(macho: URL(fileURLWithPath: macho))
        try data.write(to: URL(fileURLWithPath: outputFile), options: .atomic)
    }
}
