//
// Created by Mengyu Li on 2020/7/28.
//

import Foundation
import MachO

public struct SourceVersionLC: LoadCommand {
    public static let id = UInt32(LC_SOURCE_VERSION)

    let version: SourceVersion

    public init(machData: Data, offset: Int) {
        let command: source_version_command = machData.get(atOffset: offset)
        self.init(command: command)
    }

    public init(pointer: UnsafeRawPointer) {
        let command: source_version_command = pointer.get()
        self.init(command: command)
    }
}

private extension SourceVersionLC {
    init(command: source_version_command) {
        version = SourceVersion(version: command.version)
    }
}
