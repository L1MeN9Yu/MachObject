//
// Created by Mengyu Li on 2020/12/25.
//

import Foundation

public protocol ImageObjClass: ArchitectureDependent {
    associatedtype RODataType: ImageObjClassRO where RODataType.PointerType == PointerType
    /// Pointer to class_ro calculated from data stored in image
    var data: PointerType { get }
}
