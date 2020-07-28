//
// Created by Mengyu Li on 2020/7/24.
//

import Foundation

extension Mach {
    public enum Header {
        case _32(MachHeader32)
        case _64(MachHeader64)

        var fileType: UInt32 {
            switch self {
            case let ._32(header):
                return header.fileType
            case let ._64(header):
                return header.fileType
            }
        }

        var cupType: cpu_type_t {
            switch self {
            case let ._32(header):
                return header.cpuType
            case let ._64(header):
                return header.cpuType
            }
        }
    }
}
