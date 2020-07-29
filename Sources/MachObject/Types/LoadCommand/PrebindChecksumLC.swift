//
// Created by Mengyu Li on 2020/7/27.
//

import Foundation
import MachO

public struct PrebindChecksumLC: LoadCommand {
	public static let id: UInt32 = UInt32(LC_PREBIND_CKSUM)
	public let checkSum: UInt32

	public init(machData: Data, offset: Int) {
		let command: prebind_cksum_command = machData.get(atOffset: offset)
		checkSum = command.cksum
	}
}
