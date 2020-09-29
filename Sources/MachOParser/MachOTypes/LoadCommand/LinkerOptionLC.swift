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
        count = command.count
    }
}
