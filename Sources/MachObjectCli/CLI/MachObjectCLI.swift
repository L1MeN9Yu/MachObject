//
// Created by Mengyu Li on 2020/8/3.
//

import ArgumentParser
import Foundation

struct MachObjectCLI {
    static let version = "0.3.0"
}

extension MachObjectCLI: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "MachO CLI",
        discussion: "The MachO Toolbox",
        version: version,
        shouldDisplay: false,
        subcommands: [
            Info.self,
            StripFilePath.self,
            ReplaceString.self,
            NullifySymbolTable.self,
        ],
        defaultSubcommand: Info.self
    )
}
