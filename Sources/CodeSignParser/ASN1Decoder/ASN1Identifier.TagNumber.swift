//
// Created by Mengyu Li on 2020/10/21.
//

public extension ASN1Identifier {
    enum TagNumber: UInt8 {
        case endOfContent = 0x00
        case boolean = 0x01
        case integer = 0x02
        case bitString = 0x03
        case octetString = 0x04
        case null = 0x05
        case objectIdentifier = 0x06
        case objectDescriptor = 0x07
        case external = 0x08
        case read = 0x09
        case enumerated = 0x0A
        case embeddedPdv = 0x0B
        case utf8String = 0x0C
        case relativeOid = 0x0D
        case sequence = 0x10
        case set = 0x11
        case numericString = 0x12
        case printableString = 0x13
        case t61String = 0x14
        case videotexString = 0x15
        case ia5String = 0x16
        case utcTime = 0x17
        case generalizedTime = 0x18
        case graphicString = 0x19
        case visibleString = 0x1A
        case generalString = 0x1B
        case universalString = 0x1C
        case characterString = 0x1D
        case bmpString = 0x1E
    }
}
