//
// Created by Mengyu Li on 2020/7/27.
//

import Foundation
import MachO

public struct SubClientLC: LoadCommand {
    public static let id = UInt32(LC_SUB_CLIENT)

    public let client: String

    public init(machData: Data, offset: Int) {
        let command: sub_client_command = machData.get(atOffset: offset)
        client = String(data: machData, offset: offset, commandSize: Int(command.cmdsize), loadCommandString: command.client)
    }

    public init(pointer: UnsafeRawPointer) {
        let command: sub_client_command = pointer.get()
        client = String(loadCommandPointer: pointer, commandSize: Int(command.cmdsize), loadCommandString: command.client)
    }
}
