//
// Created by Mengyu Li on 2020/8/24.
//

import Foundation

public enum ASN1DERDecoder {
    public static func decode(data: Data) throws -> [ASN1Object] {
        var iterator = data.makeIterator()
        return try parse(iterator: &iterator)
    }

    private static func parse(iterator: inout Data.Iterator) throws -> [ASN1Object] {
        var result: [ASN1Object] = []

        while let nextValue = iterator.next() {
            let asn1obj = ASN1Object()
            asn1obj.identifier = ASN1Identifier(rawValue: nextValue)

            if asn1obj.identifier!.isConstructed {
                let contentData = try loadSubContent(iterator: &iterator)

                if contentData.isEmpty {
                    asn1obj.sub = try parse(iterator: &iterator)
                } else {
                    var subIterator = contentData.makeIterator()
                    asn1obj.sub = try parse(iterator: &subIterator)
                }

                asn1obj.value = nil

                asn1obj.rawValue = Data(contentData)

                for item in asn1obj.sub! {
                    item.parent = asn1obj
                }
            } else {
                if asn1obj.identifier!.typeClass == .universal {
                    var contentData = try loadSubContent(iterator: &iterator)

                    asn1obj.rawValue = Data(contentData)

                    // decode the content data with come more convenient format

                    switch asn1obj.identifier!.tagNumber {
                    case .endOfContent:
                        return result

                    case .boolean:
                        if let value = contentData.first {
                            asn1obj.value = value > 0 ? true : false
                        }

                    case .integer:
                        while contentData.first == 0 {
                            contentData.remove(at: 0) // remove not significant digit
                        }
                        asn1obj.value = contentData

                    case .null:
                        asn1obj.value = nil

                    case .objectIdentifier:
                        asn1obj.value = decodeOid(contentData: &contentData)

                    case .utf8String,
                         .printableString,
                         .numericString,
                         .generalString,
                         .universalString,
                         .characterString,
                         .t61String:

                        asn1obj.value = String(data: contentData, encoding: .utf8)

                    case .bmpString:
                        asn1obj.value = String(data: contentData, encoding: .unicode)

                    case .visibleString,
                         .ia5String:

                        asn1obj.value = String(data: contentData, encoding: .ascii)

                    case .utcTime:
                        asn1obj.value = dateFormatter(contentData: &contentData,
                                                      formats: ["yyMMddHHmmssZ", "yyMMddHHmmZ"])

                    case .generalizedTime:
                        asn1obj.value = dateFormatter(contentData: &contentData,
                                                      formats: ["yyyyMMddHHmmssZ"])

                    case .bitString:
                        if contentData.count > 0 {
                            _ = contentData.remove(at: 0) // unused bits
                        }
                        asn1obj.value = contentData

                    case .octetString:
                        do {
                            var subIterator = contentData.makeIterator()
                            asn1obj.sub = try parse(iterator: &subIterator)
                        } catch {
                            if let str = String(data: contentData, encoding: .utf8) {
                                asn1obj.value = str
                            } else {
                                asn1obj.value = contentData
                            }
                        }

                    default:
                        print("unsupported tag: \(asn1obj.identifier!.tagNumber)")
                        asn1obj.value = contentData
                    }
                } else {
                    // custom/private tag

                    let contentData = try loadSubContent(iterator: &iterator)

                    if let str = String(data: contentData, encoding: .utf8) {
                        asn1obj.value = str
                    } else {
                        asn1obj.value = contentData
                    }
                }
            }
            result.append(asn1obj)
        }
        return result
    }

    // Decode the number of bytes of the content
    private static func getContentLength(iterator: inout Data.Iterator) -> UInt64 {
        let first = iterator.next()

        guard first != nil else {
            return 0
        }

        if (first! & 0x80) != 0 { // long
            let octetsToRead = first! - 0x80
            var data = Data()
            for _ in 0..<octetsToRead {
                if let n = iterator.next() {
                    data.append(n)
                }
            }

            return data.uint64 ?? 0

        } else { // short
            return UInt64(first!)
        }
    }

    private static func loadSubContent(iterator: inout Data.Iterator) throws -> Data {
        let len = getContentLength(iterator: &iterator)

        guard len < Int.max else {
            return Data()
        }

        var byteArray: [UInt8] = []

        for _ in 0..<Int(len) {
            if let n = iterator.next() {
                byteArray.append(n)
            } else {
                throw ASN1Error.outOfBuffer
            }
        }
        return Data(byteArray)
    }

    // Decode DER OID bytes to String with dot notation
    static func decodeOid(contentData: inout Data) -> String {
        if contentData.isEmpty {
            return ""
        }

        var oid: String = ""

        let first = Int(contentData.remove(at: 0))
        oid.append("\(first / 40).\(first % 40)")

        var t = 0
        while contentData.count > 0 {
            let n = Int(contentData.remove(at: 0))
            t = (t << 7) | (n & 0x7F)
            if (n & 0x80) == 0 {
                oid.append(".\(t)")
                t = 0
            }
        }
        return oid
    }

    private static func dateFormatter(contentData: inout Data, formats: [String]) -> Date? {
        guard let str = String(data: contentData, encoding: .utf8) else { return nil }
        for format in formats {
            let fmt = DateFormatter()
            fmt.locale = Locale(identifier: "en_US_POSIX")
            fmt.dateFormat = format
            if let dt = fmt.date(from: str) {
                return dt
            }
        }
        return nil
    }
}
