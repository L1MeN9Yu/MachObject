//
// Created by Mengyu Li on 2020/7/27.
//

import Foundation
import MachO

public struct SubLibraryLC: LoadCommand {
    public static let id = UInt32(LC_SUB_LIBRARY)
    public let subLibrary: String

    public init(machData: Data, offset: Int) {
        let command: sub_library_command = machData.get(atOffset: offset)
        subLibrary = String(
            data: machData, offset: offset,
            commandSize: Int(command.cmdsize), loadCommandString: command.sub_library
        )
    }
}
