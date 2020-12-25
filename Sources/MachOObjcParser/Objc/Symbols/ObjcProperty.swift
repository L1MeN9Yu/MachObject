//
// Created by Mengyu Li on 2020/12/25.
//

import Foundation

public protocol ObjcProperty {
    var name: PlainStringInData { get }
    var attributes: PlainStringInData { get }
}

public extension ObjcProperty {
    var attributeValues: [String] { attributes.value.split(separator: ",").map { String($0) } }

    /// Property type string.
    /// Format is described in https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtPropertyIntrospection.html#//apple_ref/doc/uid/TP40008048-CH101-SW5
    /// but it is outdated.
    /// However it seems that property types are encoded in the same way as in methtypes, ie. they are surrounded by quotation marks, brackets, etc.
    var typeAttribute: String {
        guard let typeAttr = attributeValues.first, typeAttr.starts(with: "T") else {
            fatalError("Type attribute missing or in unexpected format for property \(name.value)")
        }
        return typeAttr
    }
}
