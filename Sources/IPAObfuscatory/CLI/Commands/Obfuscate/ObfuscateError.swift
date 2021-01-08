//
// Created by Mengyu Li on 2021/1/8.
//

import Foundation

enum ObfuscateError: Error {
    case inOutDuplicate
}

extension ObfuscateError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .inOutDuplicate: return "input output path is the same, please use a different output path"
        }
    }
}
