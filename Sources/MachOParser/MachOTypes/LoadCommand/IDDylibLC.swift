//
// Created by Mengyu Li on 2020/7/27.
//

import Foundation
import MachO

public struct IDDylibLC: LoadCommand {
    public static let id = UInt32(LC_ID_DYLIB)

    public let name: String
    public let date: Date
    public let currentVersion: Version
    public let compatibilityVersion: Version

    public init(machData: Data, offset: Int) {
        let command: dylib_command = machData.get(atOffset: offset)
        let dylib = command.dylib
        let name = String(data: machData, offset: offset, commandSize: Int(command.cmdsize), loadCommandString: dylib.name)
        self.init(dylib: dylib, name: name)
    }

    public init(pointer: UnsafeRawPointer) {
        let command: dylib_command = pointer.get()
        let dylib = command.dylib
        let name = String(loadCommandPointer: pointer, commandSize: Int(command.cmdsize), loadCommandString: dylib.name)
        self.init(dylib: dylib, name: name)
    }
}

private extension IDDylibLC {
    init(dylib: dylib, name: String) {
        self.name = name
        date = Date(timeIntervalSince1970: TimeInterval(dylib.timestamp))
        currentVersion = Version(machVersion: dylib.current_version)
        compatibilityVersion = Version(machVersion: dylib.compatibility_version)
    }
}
