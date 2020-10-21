//
// Created by Mengyu Li on 2020/10/21.
//

public extension ASN1Identifier {
    enum Class: UInt8 {
        case universal = 0x00
        case application = 0x40
        case contextSpecific = 0x80
        case `private` = 0xC0
    }
}
