//
// Created by Mengyu Li on 2020/7/27.
//

import Foundation
import MachO

public struct SubFrameworkLC: LoadCommand {
    public static let id = UInt32(LC_SUB_FRAMEWORK)

    public let umbrella: String

    public init(machData: Data, offset: Int) {
        let command: sub_framework_command = machData.get(atOffset: offset)
        umbrella = String(data: machData, offset: offset, commandSize: Int(command.cmdsize), loadCommandString: command.umbrella)
    }

    public init(pointer: UnsafeRawPointer) {
        let command: sub_framework_command = pointer.get()
        umbrella = String(loadCommandPointer: pointer, commandSize: Int(command.cmdsize), loadCommandString: command.umbrella)
    }
}
