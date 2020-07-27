//
// Created by Mengyu Li on 2020/7/27.
//

import Foundation
import MachO

public struct RunPathLC: LoadCommand {
    public static let id: UInt32 = LC_RPATH

    public let path: String

    public init(machData: Data, offset: Int) {
        let command: rpath_command = machData.get(atOffset: offset)
        path = String(data: machData, offset: offset, commandSize: Int(command.cmdsize), loadCommandString: command.path)
    }
}
