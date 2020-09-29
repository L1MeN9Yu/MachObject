//
// Created by Mengyu Li on 2020/7/27.
//

import Foundation
@_implementationOnly import MachCore
import MachO

public struct DyldEnvironmentLC: LoadCommand {
    public static let id = UInt32(LC_DYLD_ENVIRONMENT)

    public let name: String

    public init(machData: Data, offset: Int) {
        let command: dylinker_command = machData.get(atOffset: offset)
        name = String(
            data: machData, offset: offset,
            commandSize: Int(command.cmdsize), loadCommandString: command.name
        )
    }
}
