//
// Created by Mengyu Li on 2020/7/27.
//

import Foundation
import MachO

public struct SubUmbrellaLC: LoadCommand {
    public static let id: UInt32 = UInt32(LC_SUB_UMBRELLA)

    public let subUmbrella: String

    public init(machData: Data, offset: Int) {
        let command: sub_umbrella_command = machData.get(atOffset: offset)
        subUmbrella = String(
            data: machData, offset: offset,
            commandSize: Int(command.cmdsize), loadCommandString: command.sub_umbrella
        )
    }
}
