//
// Created by Mengyu Li on 2020/12/28.
//

import Foundation
import MachOParser

struct ObjcCategoryImpl<Arch: ObjcArchitecture>: FromMach {
    typealias Raw = ObjC.category_t<Arch.PointerType>
    let mach: Mach
    let offset: Int

    init(mach: Mach, offset: Int) {
        self.mach = mach
        self.offset = offset
    }
}

extension ObjcCategoryImpl: ObjcCategory {
    var name: MangledObjcClassNameInData { mach.getCString(fromVmOffset: raw.name) }

    var cls: ObjcClass? {
        guard raw.cls != 0 else { return nil }
        let offset = mach.fileOffset(fromVmOffset: raw.cls)
        return ObjcClassImpl<Arch>(mach: mach, offset: offset)
    }

    var methods: [ObjcMethod] {
        // methods_list is entsize_list_tt with flags=0x3
        let list: [ObjcMethodImpl<Arch>] = mach.get_entsize_list_tt(fromVmOffset: raw.instanceMethods, flags: 0x03)
        return list
    }

    var properties: [ObjcProperty] {
        // property_list is entsize_list_tt with flags=0
        let list: [ObjcPropertyImpl<Arch>] = mach.get_entsize_list_tt(fromVmOffset: raw.instanceProperties)
        return list
    }
}

extension ObjcCategoryImpl: CustomStringConvertible {
    var description: String { "Category \(cls?.name.value ?? "")+\(name)\n  methods: \(methods)\n  properties: \(properties)" }
}
