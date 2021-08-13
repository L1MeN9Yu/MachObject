//
// Created by Mengyu Li on 2020/7/27.
//

import Foundation
import MachO

public struct EncryptionInfo64LC: LoadCommand {
    public static let id = UInt32(LC_ENCRYPTION_INFO_64)

    public let cryptOffset: UInt32
    public let cryptSize: UInt32
    public let cryptID: UInt32
    public let pad: UInt32

    public init(machData: Data, offset: Int) {
        let command: encryption_info_command_64 = machData.get(atOffset: offset)
        self.init(command: command)
    }

    public init(pointer: UnsafeRawPointer) {
        let command: encryption_info_command_64 = pointer.get()
        self.init(command: command)
    }
}

private extension EncryptionInfo64LC {
    init(command: encryption_info_command_64) {
        cryptOffset = command.cryptoff
        cryptSize = command.cryptsize
        cryptID = command.cryptid
        pad = command.pad
    }
}
