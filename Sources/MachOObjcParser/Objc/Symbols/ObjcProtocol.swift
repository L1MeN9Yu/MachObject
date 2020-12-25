//
// Created by Mengyu Li on 2020/12/25.
//

import Foundation

public protocol ObjcProtocol {
    var name: MangledObjcClassNameInData { get }
    var methods: [ObjcMethod] { get }
    var properties: [ObjcProperty] { get }
}
