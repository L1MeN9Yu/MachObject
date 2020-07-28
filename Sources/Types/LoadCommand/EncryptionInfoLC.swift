//
// Created by Mengyu Li on 2020/7/27.
//

import Foundation
import MachO

public struct EncryptionInfoLC: LoadCommand {
	public static let id: UInt32 = UInt32(LC_ENCRYPTION_INFO)

	public let cryptOffset: UInt32
	public let cryptSize: UInt32
	public let cryptID: UInt32

	public init(machData: Data, offset: Int) {
		let command: encryption_info_command = machData.get(atOffset: offset)
		cryptOffset = command.cryptoff
		cryptSize = command.cryptsize
		cryptID = command.cryptid
	}
}
