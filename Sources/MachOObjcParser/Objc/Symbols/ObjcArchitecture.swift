//
// Created by Mengyu Li on 2020/12/25.
//

import Foundation

protocol ObjcArchitecture {
    // class_ro_t has padding that is present only in 32-bit version so we have to choose appropriate struct.
    // For other objc metadata generic 32/64-bit structs are enough.
    associatedtype ClassData: ImageObjClass

    typealias PointerType = ClassData.PointerType
}
