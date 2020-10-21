//
// Created by Mengyu Li on 2020/8/25.
//

import Foundation

public struct CodeSignature {
    public let entitlements: String?
    public let codeDirectoryList: [CodeDirectory]
    public let cmsSignature: String?

    public init(entitlements: String?, codeDirectoryList: [CodeDirectory], cmsSignature: String?) {
        self.entitlements = entitlements
        self.codeDirectoryList = codeDirectoryList
        self.cmsSignature = cmsSignature
    }
}

public extension CodeSignature {
    struct CodeDirectory {
        public let version: String
        public let ident: String
        public let team: String?
        public let hashType: HashType?

        public init(version: UInt32, ident: String, team: String?, hashType: UInt8) {
            self.version = String(version, radix: 16)
            self.ident = ident
            self.team = team
            self.hashType = HashType(rawValue: hashType)
        }
    }
}

public extension CodeSignature {
    enum HashType: UInt8 {
        case sha1 = 1
        case sha256 = 2
        case sha256Truncated = 3
        case sha384 = 4
    }
}
