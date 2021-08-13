//
// Created by Mengyu Li on 2020/7/27.
//

import Foundation
import MachO

public struct DylibCodeSignDrsLC: LoadCommand {
    public static let id = UInt32(LC_DYLIB_CODE_SIGN_DRS)

    public let dataOffset: UInt32
    public let dataSize: UInt32

    public init(machData: Data, offset: Int) {
        let command: linkedit_data_command = machData.get(atOffset: offset)
        self.init(command: command)
    }

    public init(pointer: UnsafeRawPointer) {
        let command: linkedit_data_command = pointer.get()
        self.init(command: command)
    }
}

private extension DylibCodeSignDrsLC {
    init(command: linkedit_data_command) {
        dataOffset = command.dataoff
        dataSize = command.datasize
    }
}
