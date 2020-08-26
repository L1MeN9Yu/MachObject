//
// Created by Mengyu Li on 2020/8/5.
//

import Foundation

extension SwiftMeta {
    struct ClassDescriptor {
        let flags: UInt32
        let parent: Int32
        let name: Int32
        let accessFunction: Int32
        let fieldDescriptor: Int32
        let superclassType: Int32
        let metadataNegativeSizeInWords: UInt32
        let metadataPositiveSizeInWords: UInt32
        let numImmediateMembers: UInt32
        let numFields: UInt32
    }
}

extension SwiftMeta.ClassDescriptor {
    func nameOffset(start: Int) -> Int {
        start +
            MemoryLayout.size(ofValue: flags) +
            MemoryLayout.size(ofValue: parent) +
            Int(name)
    }

    func accessFunctionOffset(start: Int) -> Int {
        start +
            MemoryLayout.size(ofValue: flags) +
            MemoryLayout.size(ofValue: parent) +
            MemoryLayout.size(ofValue: name) +
            Int(accessFunction)
    }

    func fieldDescriptorOffset(start: Int) -> Int {
        start +
            MemoryLayout.size(ofValue: flags) +
            MemoryLayout.size(ofValue: parent) +
            MemoryLayout.size(ofValue: name) +
            MemoryLayout.size(ofValue: accessFunction) +
            Int(fieldDescriptor)
    }

    func superclassTypeOffset(start: Int) -> Int? {
        if superclassType == 0 { return nil }
        return start +
            MemoryLayout.size(ofValue: flags) +
            MemoryLayout.size(ofValue: parent) +
            MemoryLayout.size(ofValue: name) +
            MemoryLayout.size(ofValue: accessFunction) +
            MemoryLayout.size(ofValue: fieldDescriptor) +
            Int(superclassType)
    }
}
