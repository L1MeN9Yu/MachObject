//
// Created by Mengyu Li on 2020/12/25.
//

import Foundation

public protocol ObjcCategory {
    var name: MangledObjcClassNameInData { get }
    /// Class to which this category is related
    var cls: ObjcClass? { get }
    var methods: [ObjcMethod] { get }
    var properties: [ObjcProperty] { get }
}
