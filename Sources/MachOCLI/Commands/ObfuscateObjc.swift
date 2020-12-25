//
// Created by Mengyu Li on 2020/12/25.
//

import ArgumentParser
import Foundation
import MachOEditor

struct ObfuscateObjc: ParsableCommand {
    @Argument(help: ArgumentHelp(stringLiteral: "macho file path"))
    var macho: String

    @Argument(help: ArgumentHelp(stringLiteral: "output file path"))
    var outputFile: String

    func run() throws {}
}
