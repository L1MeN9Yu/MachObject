//
// Created by Mengyu Li on 2020/7/28.
//

import Foundation
import MachO

public struct NoteLC: LoadCommand {
    public static let id = UInt32(LC_NOTE)
    public let owner: String
    public let fileOffset: UInt64
    public let fileSize: UInt64

    public init(machData: Data, offset: Int) {
        let command: note_command = machData.get(atOffset: offset)
        owner = String(bytesTuple: command.data_owner)
        fileOffset = command.offset
        fileSize = command.size
    }
}
