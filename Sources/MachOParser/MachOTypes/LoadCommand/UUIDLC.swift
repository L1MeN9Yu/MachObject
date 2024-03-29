//
// Created by Mengyu Li on 2020/7/27.
//

import Foundation
@_implementationOnly import MachCore
import MachO

public struct UUIDLC: LoadCommand {
    public static let id = UInt32(LC_UUID)

    public let uuid: UUID

    public init(machData: Data, offset: Int) {
        let command: uuid_command = machData.get(atOffset: offset)
        self.init(command: command)
    }

    public init(pointer: UnsafeRawPointer) {
        let command: uuid_command = pointer.get()
        self.init(command: command)
    }
}

private extension UUIDLC {
    init(command: uuid_command) {
        uuid = UUID(uuid: command.uuid)
    }
}
