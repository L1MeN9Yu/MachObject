//
// Created by Mengyu Li on 2020/12/25.
//

import Foundation

public protocol ImageObjClassRO: ArchitectureDependent {
    var ivarLayout: PointerType { get }
    var name: PointerType { get }
    var baseMethodList: PointerType { get }
    var baseProtocols: PointerType { get }
    var ivars: PointerType { get }
    var weakIvarLayout: PointerType { get }
    var baseProperties: PointerType { get }
}
