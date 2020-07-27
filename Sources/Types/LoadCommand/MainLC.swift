//
// Created by Mengyu Li on 2020/7/27.
//

import Foundation
import MachO

public struct MainLC: LoadCommand {
    public static let id: UInt32 = LC_MAIN

    public let entryOffset: UInt64 /* file (__TEXT) offset of main() */
    public let stackSize: UInt64 /* if not zero, initial stack size */

    public init(machData: Data, offset: Int) {
        let command: entry_point_command = machData.get(atOffset: offset)
        entryOffset = command.entryoff
        stackSize = command.stacksize
    }
}
