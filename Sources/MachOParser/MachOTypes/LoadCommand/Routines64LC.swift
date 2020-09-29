//
// Created by Mengyu Li on 2020/7/27.
//

import Foundation
import MachO

public struct Routines64LC: LoadCommand {
    public static let id = UInt32(LC_ROUTINES_64)

    public let initAddress: UInt64
    public let initModule: UInt64
    public let reserved1: UInt64
    public let reserved2: UInt64
    public let reserved3: UInt64
    public let reserved4: UInt64
    public let reserved5: UInt64
    public let reserved6: UInt64

    public init(machData: Data, offset: Int) {
        let command: routines_command_64 = machData.get(atOffset: offset)
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
