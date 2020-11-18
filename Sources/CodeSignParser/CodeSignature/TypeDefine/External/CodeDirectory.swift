//
// Created by Mengyu Li on 2020/11/18.
//

import Foundation

public struct CodeDirectory {
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
