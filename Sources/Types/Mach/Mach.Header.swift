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
            case ._32(let header):
                return header.fileType
            case ._64(let header):
                return header.fileType
            }
        }
    }
}