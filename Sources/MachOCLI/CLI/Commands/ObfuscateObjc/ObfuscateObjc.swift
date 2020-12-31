//
// Created by Mengyu Li on 2020/12/25.
//

import ArgumentParser
import Foundation
import MachOEditor

struct ObfuscateObjc: ParsableCommand {
    @Argument(help: ArgumentHelp(stringLiteral: "macho file path"))
    var macho: String

    @Argument(help: ArgumentHelp(stringLiteral: "config file path"))
    var configFile: String

    @Argument(help: ArgumentHelp(stringLiteral: "output file path"))
    var outputFile: String

    func run() throws {
        let obfuscatedData = try Editor.obfuscateObjC(mach: URL(fileURLWithPath: macho))
        try obfuscatedData.write(to: URL(fileURLWithPath: outputFile), options: .atomic)
    }
}
