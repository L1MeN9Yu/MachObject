//
// Created by Mengyu Li on 2020/7/24.
//

import Foundation

extension Mach {
	public enum Header {
		case _32(MachHeader32)
		case _64(MachHeader64)

		var fileType: FileType {
			switch self {
			case let ._32(header):
				return FileType(fileType: header.fileType)
			case let ._64(header):
				return FileType(fileType: header.fileType)
			}
		}

		var cpuType: CPUType {
			switch self {
			case let ._32(header):
				return CPUType(cpuType: header.cpuType)
			case let ._64(header):
				return CPUType(cpuType: header.cpuType)
			}
		}

		var readableFlag: Set<MachHeaderFlag> {
			switch self {
			case let ._32(header):
				return Set<MachHeaderFlag>(rawValue: Int(header.flags))
			case let ._64(header):
				return Set<MachHeaderFlag>(rawValue: Int(header.flags))
			}
		}
	}
}
