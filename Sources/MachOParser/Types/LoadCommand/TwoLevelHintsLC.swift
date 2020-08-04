//
// Created by Mengyu Li on 2020/7/27.
//

import Foundation
import MachO

public struct TwoLevelHintsLC: LoadCommand {
	public static let id: UInt32 = UInt32(LC_TWOLEVEL_HINTS)
	public let hintOffset: UInt32
	public let hintCount: UInt32

	public init(machData: Data, offset: Int) {
		let command: twolevel_hints_command = machData.get(atOffset: offset)
		hintOffset = command.offset
		hintCount = command.nhints
	}
}
