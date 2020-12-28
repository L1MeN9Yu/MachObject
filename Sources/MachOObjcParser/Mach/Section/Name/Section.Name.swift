//
// Created by Mengyu Li on 2020/12/28.
//

import Foundation
import MachOParser

public extension SectionName {
    static let __objc_methname = Self(rawValue: "__objc_methname")
    static let __objc_methtype = Self(rawValue: "__objc_methtype")
    static let __objc_classname = Self(rawValue: "__objc_classname")
    static let __objc_classlist = Self(rawValue: "__objc_classlist")
    static let __objc_protolist = Self(rawValue: "__objc_protolist")
    static let __objc_catlist = Self(rawValue: "__objc_catlist")
}
