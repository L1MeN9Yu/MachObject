//
// Created by Mengyu Li on 2020/7/27.
//

import Foundation
import MachO

public struct PrebindChecksumLC: LoadCommand {
    public static let id = UInt32(LC_PREBIND_CKSUM)
    public let checkSum: UInt32

    public init(machData: Data, offset: Int) {
        let command: prebind_cksum_command = machData.get(atOffset: offset)
        self.init(command: command)
    }

    public init(pointer: UnsafeRawPointer) {
        let command: prebind_cksum_command = pointer.get()
        self.init(command: command)
    }
}

private extension PrebindChecksumLC {
    init(command: prebind_cksum_command) {
        checkSum = command.cksum
    }
}
