//
// Created by Mengyu Li on 2020/7/28.
//

import Foundation
import MachO

public struct LinkerOptimizationHintLC: LoadCommand {
	public static let id: UInt32 = UInt32(LC_LINKER_OPTIMIZATION_HINT)

	public let dataOffset: UInt32
	public let dataSize: UInt32

	public init(machData: Data, offset: Int) {
		let command: linkedit_data_command = machData.get(atOffset: offset)
		dataOffset = command.dataoff
		dataSize = command.datasize
	}
}
