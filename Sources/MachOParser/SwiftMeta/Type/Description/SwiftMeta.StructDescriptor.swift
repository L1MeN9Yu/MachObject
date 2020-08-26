//
// Created by Mengyu Li on 2020/8/5.
//

import Foundation

extension SwiftMeta {
    struct StructDescriptor {
        let flags: UInt32
        let parent: Int32
        let name: Int32
        let accessFunction: Int32
        let fieldDescriptor: Int32
        let numFields: UInt32
        let fieldOffsetVectorOffset: UInt32
    }
}

extension SwiftMeta.StructDescriptor {
    func nameOffset(start: Int) -> Int {
        start +
            MemoryLayout.size(ofValue: flags) +
            MemoryLayout.size(ofValue: parent) +
            Int(name)
    }
}
