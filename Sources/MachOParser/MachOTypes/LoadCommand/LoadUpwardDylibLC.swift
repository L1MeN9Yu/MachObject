//
// Created by Mengyu Li on 2020/7/27.
//

import Foundation
import MachO

public struct LoadUpwardDylibLC: LoadCommand {
	public static let id: UInt32 = LC_LOAD_UPWARD_DYLIB

	public let name: String
	public let date: Date
	public let currentVersion: Version
	public let compatibilityVersion: Version

	public init(machData: Data, offset: Int) {
		let command: dylib_command = machData.get(atOffset: offset)
		let dylib = command.dylib
		name = String(data: machData, offset: offset, commandSize: Int(command.cmdsize), loadCommandString: dylib.name)
		date = Date(timeIntervalSince1970: TimeInterval(dylib.timestamp))
		currentVersion = Version(machVersion: dylib.current_version)
		compatibilityVersion = Version(machVersion: dylib.compatibility_version)
	}
}
