//
// Created by Mengyu Li on 2020/7/27.
//

import Foundation
import MachO

public struct SegmentSplitInfoLC: LoadCommand {
	public static let id: UInt32 = UInt32(LC_SEGMENT_SPLIT_INFO)

	public let dataOffset: UInt32
	public let dataSize: UInt32

	public init(machData: Data, offset: Int) {
		let command: linkedit_data_command = machData.get(atOffset: offset)
		dataOffset = command.dataoff
		dataSize = command.datasize
	}
}
