//
// Created by Mengyu Li on 2020/8/7.
//

import Foundation

extension SwiftMeta {
    struct FieldRecord {
        let flags: UInt32
        let mangledTypeName: Int32
        let fieldName: Int32
    }
}

extension SwiftMeta.FieldRecord {
    func mangledTypeNameOffset(start: Int) -> Int {
        start +
            MemoryLayout.size(ofValue: flags) +
            Int(mangledTypeName)
    }

    func fieldNameOffset(start: Int) -> Int {
        start +
            MemoryLayout.size(ofValue: flags) +
            MemoryLayout.size(ofValue: mangledTypeName) +
            Int(fieldName)
    }
}
