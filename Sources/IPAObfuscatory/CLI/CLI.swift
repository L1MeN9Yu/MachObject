//
// Created by Mengyu Li on 2021/1/7.
//

import ArgumentParser
import Foundation

struct CLI: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "MachO CLI",
        discussion: "The MachO Tool",
        version: "0.0.1",
        shouldDisplay: false,
        subcommands: [
            Obfuscate.self,
        ],
        defaultSubcommand: Obfuscate.self
    )
}
