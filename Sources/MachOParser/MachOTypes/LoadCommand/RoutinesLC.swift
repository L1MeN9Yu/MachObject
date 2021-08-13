//
// Created by Mengyu Li on 2020/7/27.
//

import Foundation
import MachO

public struct RoutinesLC: LoadCommand {
    public static let id = UInt32(LC_ROUTINES)

    public let initAddress: UInt32
    public let initModule: UInt32
    public let reserved1: UInt32
    public let reserved2: UInt32
    public let reserved3: UInt32
    public let reserved4: UInt32
    public let reserved5: UInt32
    public let reserved6: UInt32

    public init(machData: Data, offset: Int) {
        let command: routines_command = machData.get(atOffset: offset)
        self.init(command: command)
    }

    public init(pointer: UnsafeRawPointer) {
        let command: routines_command = pointer.get()
        self.init(command: command)
    }
}

private extension RoutinesLC {
    init(command: routines_command) {
        initAddress = command.init_address
        initModule = command.init_module
        reserved1 = command.reserved1
        reserved2 = command.reserved2
        reserved3 = command.reserved3
        reserved4 = command.reserved4
        reserved5 = command.reserved5
        reserved6 = command.reserved6
    }
}
