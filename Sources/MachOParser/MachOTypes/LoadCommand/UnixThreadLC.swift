//
// Created by Mengyu Li on 2020/7/24.
//

import Foundation
import MachO

public struct UnixThreadLC: LoadCommand {
    public static let id: UInt32 = UInt32(LC_UNIXTHREAD)

    private let thread: thread_command

    public init(machData: Data, offset: Int) {
        thread = machData.get(atOffset: offset)
    }
}
