//
// Created by Mengyu Li on 2020/7/27.
//

import Foundation
import MachO

public struct DyldInfoOnlyLC: LoadCommand {
    public static let id: UInt32 = LC_DYLD_INFO_ONLY

    public let rebaseOffset: UInt32
    public let rebaseSize: UInt32
    public let bindOffset: UInt32
    public let bindSize: UInt32
    public let weakBindOffset: UInt32
    public let weakBindSize: UInt32
    public let lazyBindOffset: UInt32
    public let lazyBindSize: UInt32
    public let exportOffset: UInt32
    public let exportSize: UInt32

    public init(machData: Data, offset: Int) {
        let command: dyld_info_command = machData.get(atOffset: offset)
        self.init(command: command)
    }

    public init(pointer: UnsafeRawPointer) {
        let command: dyld_info_command = pointer.get()
        self.init(command: command)
    }
}

private extension DyldInfoOnlyLC {
    init(command: dyld_info_command) {
        rebaseOffset = command.rebase_off
        rebaseSize = command.rebase_size
        bindOffset = command.bind_off
        bindSize = command.bind_size
        weakBindOffset = command.weak_bind_off
        weakBindSize = command.weak_bind_size
        lazyBindOffset = command.lazy_bind_off
        lazyBindSize = command.lazy_bind_size
        exportOffset = command.export_off
        exportSize = command.export_size
    }
}
