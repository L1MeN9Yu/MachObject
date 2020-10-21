//
// Created by Mengyu Li on 2020/8/24.
//

import Foundation

public class ASN1Object: CustomStringConvertible {
    /// This property contains the DER encoded object
    public var rawValue: Data?

    /// This property contains the decoded Swift object whenever is possible
    public var value: Any?

    public var identifier: ASN1Identifier?

    var sub: [ASN1Object]?

    weak var parent: ASN1Object?

    public func sub(_ index: Int) -> ASN1Object? {
        if let sub = self.sub, index >= 0, index < sub.count {
            return sub[index]
        }
        return nil
    }

    public func subCount() -> Int {
        sub?.count ?? 0
    }

    public func findOid(_ oid: OID) -> ASN1Object? {
        findOid(oid.rawValue)
    }

    public func findOid(_ oid: String) -> ASN1Object? {
        for child in sub ?? [] {
            if child.identifier?.tagNumber == .objectIdentifier {
                if child.value as? String == oid {
                    return child
                }
            } else {
                if let result = child.findOid(oid) {
                    return result
                }
            }
        }
        return nil
    }

    public var description: String {
        printAsn1()
    }

    fileprivate func printAsn1(insets: String = "") -> String {
        var output = insets
        output.append(identifier?.description.capitalized ?? "")
        output.append(value != nil ? ": \(value!)" : "")
        if identifier?.typeClass == .universal, identifier?.tagNumber == .objectIdentifier {
            if let oidName = OID.description(of: value as? String ?? "") {
                output.append(" (\(oidName))")
            }
        }
        output.append(sub != nil && sub!.count > 0 ? " {" : "")
        output.append("\n")
        for item in sub ?? [] {
            output.append(item.printAsn1(insets: insets + "    "))
        }
        output.append(sub != nil && sub!.count > 0 ? insets + "}\n" : "")
        return output
    }
}
