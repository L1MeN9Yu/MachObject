//
// Created by Mengyu Li on 2020/12/25.
//

import Foundation

public protocol ObjcClass {
    var ivarLayout: PlainStringInData? { get }
    var name: MangledObjcClassNameInData { get }
    var ivars: [ObjcIvar] { get }
    var methods: [ObjcMethod] { get }
    var properties: [ObjcProperty] { get }
}
