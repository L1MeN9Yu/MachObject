//
// Created by Mengyu Li on 2020/7/28.
//

import Foundation
import MachO

public struct LinkerOptionLC: LoadCommand {
    public static let id = UInt32(LC_LINKER_OPTION)

    public let count: UInt32

    public init(machData: Data, offset: Int) {
        let command: linker_option_command = machData.get(atOffset: offset)
        self.init(command: command)
    }

    public init(pointer: UnsafeRawPointer) {
        let command: linker_option_command = pointer.get()
        self.init(command: command)
    }
}

private extension LinkerOptionLC {
    init(command: linker_option_command) {
        count = command.count
    }
}
