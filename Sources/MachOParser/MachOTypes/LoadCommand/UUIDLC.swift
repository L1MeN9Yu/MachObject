//
// Created by Mengyu Li on 2020/7/27.
//

import Foundation
import MachO

public struct UUIDLC: LoadCommand {
    public static let id: UInt32 = UInt32(LC_UUID)

    public let uuid: UUID

    public init(machData: Data, offset: Int) {
        let command: uuid_command = machData.get(atOffset: offset)
        uuid = UUID(uuid: command.uuid)
    }
}
